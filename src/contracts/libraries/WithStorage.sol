// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;

// Types

import { FighterBody, Fighter } from "../FyteTypes.sol";

/*//////////////////////////////////////////////////////////////
                                STRUCTS
//////////////////////////////////////////////////////////////*/

struct GameStorage {
    // Diamond
    address diamondAddress;
    // Admin Controls
    bool paused;
    // Figthers
    mapping(uint256 => Fighter) fighters;
    mapping(FighterBody => uint256) fighterMintCosts;
}

library LibStorage {
    bytes32 internal constant GAME_STORAGE_POSITION = keccak256("fyte.storage.game");

    function gameStorage() internal pure returns (GameStorage storage gs) {
        bytes32 position = GAME_STORAGE_POSITION;
        assembly {
            gs.slot := position
        }
    }
}

contract WithStorage {
    function gs() internal pure returns (GameStorage storage) {
        return LibStorage.gameStorage();
    }
}
