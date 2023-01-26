// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/// @title UUIDv4
/// @author horsefacts <webmaster@terminally.online>
/// @notice parse and format UUIDv4 as bytes16
library UUID {
    error InvalidLength();
    error MalformedUUID();
    error InvalidByte();

    bytes16 private constant _SYMBOLS = "0123456789abcdef";

    /// @notice Format a bytes16 UUIDv4 as a string:
    /// hex: 0x07ad2cedd8134b1496795389d38f7a5e
    /// formatted: 07ad2ced-d813-4b14-9679-5389d38f7a5e
    /// @param uuid bytes16 UUIDv4
    /// @return formatted UUID, with separators
    function toString(bytes16 uuid) internal pure returns (string memory) {
        return string.concat(
            _toHexString(uint128(uuid) >> 96, 8),
            "-",
            _toHexString(uint128(uuid & 0x00000000ffff00000000000000000000) >> 80, 4),
            "-",
            _toHexString(uint128(uuid & 0x000000000000ffff0000000000000000) >> 64, 4),
            "-",
            _toHexString(uint128(uuid & 0x0000000000000000ffff000000000000) >> 48, 4),
            "-",
            _toHexString(uint128(uuid & 0x00000000000000000000ffffffffffff), 12)
        );
    }

    /// @notice Parse a dash-separated UUID string to bytes16
    /// string: "07ad2ced-d813-4b14-9679-5389d38f7a5e"
    /// parsed: bytes16(0x07ad2cedd8134b1496795389d38f7a5e)
    /// @param uuid Dash-separated UUID string
    /// @return parsed UUID as bytes16
    function parse(string memory uuid) internal pure returns (bytes16) {
        bytes memory str = bytes(uuid);

        // UUIDv4 must be exactly 36 bytes long, including separators
        if (str.length != 36) revert InvalidLength();

        // We'll parse the string byte by byte into a uint128
        uint128 num;

        unchecked {
            for (uint256 i; i < str.length; ++i) {
                // Get one char from the UUID string
                bytes1 b = str[i];

                // If we are at any of these indexes, the char must be a dash
                if (i == 8 || i == 13 || i == 18 || i == 23) {
                    // If it's not a dash (char 0x2d), the UUID is malformed
                    if (b != 0x2d) revert MalformedUUID();
                    // If it is, ignore it and parse the next char
                    continue;
                }

                num <<= 4;
                // If the character is in this range, it's 0-9
                if (b > 0x2f && b < 0x3a) {
                    num |= (uint8(b) - 0x30);
                // If the character is in this range, it's a-f
                } else if (b > 0x60 && b < 0x67) {
                    num |= (uint8(b) - 0x57);
                // Any other character is invalid
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
