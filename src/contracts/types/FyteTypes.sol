// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/*//////////////////////////////////////////////////////////////
                      FIGHTER
//////////////////////////////////////////////////////////////*/

enum FighterBody {
    BOB,
    JIN
}

struct FigtherMintArgs {
    FighterBody body;
    address owner;
}

struct Fighter {
    uint256 id;
    FighterBody body;
    Attack[8] attacks;
}

// TO:DO add -> mapping(uint16 => Item) items;
// TO:DO add -> mapping(uint16 => Talents) talents; ?

/*//////////////////////////////////////////////////////////////
                      MOVE
//////////////////////////////////////////////////////////////*/

struct Force {
    uint256 x;
    uint256 y;
    uint256 m; // mass
    uint256 a; // acceleration
    uint256 f; // force
}

/*//////////////////////////////////////////////////////////////
                                 ATTACK
//////////////////////////////////////////////////////////////*/

struct Attack {
    // Metadata
    uint8 slot;
    string name;
    // Static Force Direction (Character Movement with Attack)
    Force staticForce; // TO:DO -> ANIMATION STUFF
    // Attack hitbox
    Hitbox hitbox;
    // Damage
    Damage damage; // TO:DO -> add hitstun/lag
    // Konckback
}

struct Damage {
    uint256 amount; // TO:DO -> add combo damage
    uint256 minimum;
}

struct Hitbox {
    uint256 width;
    uint256 height;
    uint256 x;
    uint256 y;
}
