// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/*//////////////////////////////////////////////////////////////
                      FIGHTER
//////////////////////////////////////////////////////////////*/

enum FighterBody {
    JIN, // Placeholder names
    KAZUYA
}

struct FigtherMintArgs {
    FighterBody body;
    address owner;
}

struct Fighter {
    uint256 id;
    FighterBody body;
    mapping(uint8 => Move) moves;
}
// mapping(uint16 => Item) items;

/*//////////////////////////////////////////////////////////////
                      MOVE
//////////////////////////////////////////////////////////////*/

struct Move {
    uint8 slot;
    uint128 speed;
    uint128 range;
    uint128 damage;
    uint128 cooldown;
}
