// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/// @title UUID
/// @author horsefacts
/// @notice Parse and format UUIDs as `bytes16`
library UUID {
    /// @notice The input string has an invalid length. Must be exactly 36 chars.
    error InvalidLength();
    /// @notice The input string contains separator characters in the wrong positions.
    error MalformedUUID();
    /// @notice The input string contains an invalid character. Must contain only `[0-9a-f]` and the `-` separator.
    error InvalidByte();

    bytes16 private constant _SYMBOLS = "0123456789abcdef";

    uint128 private constant _FOUR_BYTE_MASK = 0xffff;
    uint128 private constant _TWELVE_BYTE_MASK = 0xffffffffffff;

    /// @dev 0x00000000ffff00000000000000000000
    bytes16 private constant _GROUP_2_MASK = bytes16(_FOUR_BYTE_MASK << 80);
    /// @dev 0x000000000000ffff0000000000000000
    bytes16 private constant _GROUP_3_MASK = bytes16(_FOUR_BYTE_MASK << 64);
    /// @dev 0x0000000000000000ffff000000000000
    bytes16 private constant _GROUP_4_MASK = bytes16(_FOUR_BYTE_MASK << 48);
    /// @dev 0x00000000000000000000ffffffffffff
    bytes16 private constant _GROUP_5_MASK = bytes16(_TWELVE_BYTE_MASK);

    /// @notice Format a bytes16 UUID as a string.
    ///
    /// bytes16: `bytes16(0x07ad2cedd8134b1496795389d38f7a5e)`
    /// string: `"07ad2ced-d813-4b14-9679-5389d38f7a5e"`
    ///
    /// @param uuid bytes16 UUID
    /// @return 36 character formatted UUID, with separators
    function toString(bytes16 uuid) internal pure returns (string memory) {
        return string.concat(
            _toHexString(uint128(uuid) >> 96, 8),
            "-",
            _toHexString(uint128(uuid & _GROUP_2_MASK) >> 80, 4),
            "-",
            _toHexString(uint128(uuid & _GROUP_3_MASK) >> 64, 4),
            "-",
            _toHexString(uint128(uuid & _GROUP_4_MASK) >> 48, 4),
            "-",
            _toHexString(uint128(uuid & _GROUP_5_MASK), 12)
        );
    }

    /// @notice Parse a dash-separated UUID string to `bytes16`.
    ///
    /// string: `"07ad2ced-d813-4b14-9679-5389d38f7a5e"`
    /// bytes16: `bytes16(0x07ad2cedd8134b1496795389d38f7a5e)`
    ///
    /// @param uuid 36 character dash-separated UUID string.
    /// @return parsed UUID as bytes16
    function parse(string memory uuid) internal pure returns (bytes16) {
        bytes memory str = bytes(uuid);

        // A UUID string must be exactly 36 chars long, including separators.
        // Two chars per byte * 16 bytes + 4 separators = 36 chars.
        if (str.length != 36) revert InvalidLength();

        // We'll parse the string byte by byte into a uint128
        uint128 num;

        unchecked {
            for (uint256 i; i < str.length; ++i) {
                // Get one char from the UUID string
                bytes1 b = str[i];

                // If we are at any of these indexes, the char must be a dash
                if (i == 8 || i == 13 || i == 18 || i == 23) {
                    // If it's not a dash (0x2d), the UUID is malformed
                    if (b != 0x2d) revert MalformedUUID();
                    // If it is a dash, ignore it and parse the next char
                    continue;
                }

                // Each individual char is half a hex byte, so we
                // shift the current value left by 4 bits.
                num <<= 4;
                // If the char is in this range, it's [0-9]
                if (b > 0x2f && b < 0x3a) {
                    num |= (uint8(b) - 0x30);
                    // If the char is in this range, it's [a-f]
                } else if (b > 0x60 && b < 0x67) {
                    num |= (uint8(b) - 0x57);
                    // Any other char is invalid
                } else {
                    revert InvalidByte();
                }
            }
        }
        // Return parsed UUID as a bytes16
        return bytes16(num);
    }

    /// @dev Convert integer value to hex string. Based on OZ Strings#toHexString.
    function _toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(length);
        for (uint256 i = length - 1; i > 0; --i) {
            buffer[i] = _SYMBOLS[value & 0xf];
            value >>= 4;
        }
        buffer[0] = _SYMBOLS[value & 0xf];
        value >>= 4;
        return string(buffer);
    }
}
