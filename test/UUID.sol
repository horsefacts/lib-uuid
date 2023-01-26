// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/UUIDv4.sol";

contract UUIDv4Test is Test {
    string internal TOO_LONG = "07ad2ced-d813-4b14-9679-5389d38f7a5e0";
    string internal TOO_SHORT = "07ad2ced-d813-4b14-9679-5389d38f7a5";

    string internal MALFORMED_1 = "07ad2cedd-813-4b14-9679-5389d38f7a5e";
    string internal MALFORMED_2 = "07ad2ced-d8134-b14-9679-5389d38f7a5e";
    string internal MALFORMED_3 = "07ad2ced-d813-4b149-679-5389d38f7a5e";
    string internal MALFORMED_4 = "07ad2ced-d813-4b14-96795-389d38f7a5e";

    string internal INVALID_BYTE_1 = "07Ad2ced-d813-4b14-9679-5389d38f7a5e";
    string internal INVALID_BYTE_2 = "07ad2ced- 813-4b14-9679-5389d38f7a5e";
    string internal INVALID_BYTE_3 = "07ad2ced-d813-.b14-9679-5389d38f7a5e";
    string internal INVALID_BYTE_4 = "07ad2ced-d813-4b14-9679-5389d38f7a5g";

    string internal VALID_1 = "07ad2ced-d813-4b14-9679-5389d38f7a5e";
    string internal VALID_2 = "1ab0f6a1-a141-48c4-ae40-cc2e2913d504";
    string internal VALID_3 = "e6851052-e94b-455b-adf0-3986cc0ede55";
    string internal VALID_4 = "32b97deb-a706-49cb-ab41-acdd546037a1";

    function test_parseTooLong() public {
        vm.expectRevert(UUIDv4.InvalidLength.selector);
        UUIDv4.parse(TOO_LONG);
    }

    function test_parseTooShort() public {
        vm.expectRevert(UUIDv4.InvalidLength.selector);
        UUIDv4.parse(TOO_LONG);
    }

    function test_parseMalformed1() public {
        vm.expectRevert(UUIDv4.MalformedUUID.selector);
        UUIDv4.parse(MALFORMED_1);
    }

    function test_parseMalformed2() public {
        vm.expectRevert(UUIDv4.MalformedUUID.selector);
        UUIDv4.parse(MALFORMED_2);
    }

    function test_parseMalformed3() public {
        vm.expectRevert(UUIDv4.MalformedUUID.selector);
        UUIDv4.parse(MALFORMED_3);
    }

    function test_parseMalformed4() public {
        vm.expectRevert(UUIDv4.MalformedUUID.selector);
        UUIDv4.parse(MALFORMED_4);
    }

    function test_parseInvalidByte1() public {
        vm.expectRevert(UUIDv4.InvalidByte.selector);
        UUIDv4.parse(INVALID_BYTE_1);
    }

    function test_parseInvalidByte2() public {
        vm.expectRevert(UUIDv4.InvalidByte.selector);
        UUIDv4.parse(INVALID_BYTE_2);
    }

    function test_parseInvalidByte3() public {
        vm.expectRevert(UUIDv4.InvalidByte.selector);
        assertEq(UUIDv4.parse(INVALID_BYTE_3), "");
    }

    function test_parseInvalidByte4() public {
        vm.expectRevert(UUIDv4.InvalidByte.selector);
        UUIDv4.parse(INVALID_BYTE_4);
    }

    function test_parseValid() public {
        assertEq(UUIDv4.parse(VALID_1), bytes16(0x07ad2cedd8134b1496795389d38f7a5e));
        assertEq(UUIDv4.parse(VALID_2), bytes16(0x1ab0f6a1a14148c4ae40cc2e2913d504));
        assertEq(UUIDv4.parse(VALID_3), bytes16(0xe6851052e94b455badf03986cc0ede55));
        assertEq(UUIDv4.parse(VALID_4), bytes16(0x32b97deba70649cbab41acdd546037a1));
    }

    function test_format() public {
        assertEq(UUIDv4.toString(bytes16(0x07ad2cedd8134b1496795389d38f7a5e)), VALID_1);
        assertEq(UUIDv4.toString(bytes16(0x1ab0f6a1a14148c4ae40cc2e2913d504)), VALID_2);
        assertEq(UUIDv4.toString(bytes16(0xe6851052e94b455badf03986cc0ede55)), VALID_3);
        assertEq(UUIDv4.toString(bytes16(0x32b97deba70649cbab41acdd546037a1)), VALID_4);
    }
}
