// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

// Contracts

// Libraries

import { LibDiamond } from "../dependencies/libraries/LibDiamond.sol";

// Storage

import { WithStorage } from "../libraries/WithStorage.sol";

// Types

contract FyteAdminFacet is WithStorage {
    /*//////////////////////////////////////////////////////////////
                                  EVENTS
    //////////////////////////////////////////////////////////////*/

    event PauseStateChanged(bool paused);

    /*//////////////////////////////////////////////////////////////
                                MODIFIERS
    //////////////////////////////////////////////////////////////*/

    modifier onlyAdmin() {
        LibDiamond.enforceIsContractOwner(); // TO:DO export modifiers to shared lib
        _;
    }

    /*//////////////////////////////////////////////////////////////
                                 EXTERNAL
    //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
                                  PUBLIC
    //////////////////////////////////////////////////////////////*/

    function pause() public onlyAdmin {
        require(!gs().paused, "Already paused");
        gs().paused = true;
        emit PauseStateChanged(true);
    }

    function unpause() public onlyAdmin {
        require(gs().paused, "Already unpaused");
        gs().paused = false;
        emit PauseStateChanged(false);
    }

    function withdraw(uint256 amount) public onlyAdmin {
        require(address(this).balance >= amount, "Insufficient balance");
        payable(LibDiamond.contractOwner()).transfer(address(this).balance - amount);
    }

    /*//////////////////////////////////////////////////////////////
                                  INTERNAL
    //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
                                  PRIVATE
    //////////////////////////////////////////////////////////////*/
}
