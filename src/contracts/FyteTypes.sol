// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/*//////////////////////////////////////////////////////////////
                      FIGHTER
//////////////////////////////////////////////////////////////*/

enum FighterBody {
    JIN, // Placeholder names
    KAZUYA
}

struct FighterMintArgs {
    FighterBody body;
    address owner;
}

struct Fighter {
    uint256 id;
    FighterBody body;
    Move[8] moves;
}

// TO:DO add -> mapping(uint16 => Item) items;
// TO:DO add -> mapping(uint16 => Talents) talents; ?

/*//////////////////////////////////////////////////////////////
                      MOVE
//////////////////////////////////////////////////////////////*/

struct Move {
    uint8 slot;
    uint8 cooldown;
    uint128 speed;
    uint128 range;
    uint128 damage;
}
