# lib-uuid

A Solidity helper library to parse/format UUIDs to and from `bytes16`.

## About UUIDs
[UUIDs](https://en.wikipedia.org/wiki/Universally_unique_identifier) are 128 bit labels frequently used as unique, randomly generated IDs.

The canonical string representation of a UUID is a 36 character string with 5 groups of hex digits separated by hyphens:

```
07ad2ced-d813-4b14-9679-5389d38f7a5e
```

UUIDs are serialized as strings (and often stored as strings when storage efficiency doesn't matter much), but they can be much more efficiently stored as bytes.

Storing an off chain UUID as a Solidity `string` requires writing to three storage slots:
- Slot 1: The string's length, mostly empty.
- Slot 2: The first 32 characters of the string.
- Slot 3: The remaining 4 characters, mostly empty.

This is expensive to read and write!

A UUID can instead be stored as 16 rather than 36 bytes. For example, the UUID above can be stored as:

```
bytes16(0x07ad2cedd8134b1496795389d38f7a5e)
```

This is exactly half a storage slot, leaving plenty of room to pack it with other data, like a `uint128`.

## Functions
- `parse(string memory uuid) returns (bytes16)`:
    - Parse a 36-character dash separated UUID string to a `bytes16`. Reverts if the string is not exactly 36 characters. Reverts if separators are malformed. Reverts if the string contains any non-separator characters other than `[0-9a-f]`.
- `toString(bytes16 uuid) returns (string memory)`:
    - Format a `bytes16` UUID as a hyphen separated string.
