// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Contracts

import { SolidStateERC721 as ERC721 } from "solidstate-solidity/token/ERC721/SolidStateERC721.sol";
import { ERC721BaseStorage } from "solidstate-solidity/token/ERC721/base/ERC721BaseStorage.sol";

// Libraries

import { LibDiamond } from "../dependencies/libraries/LibDiamond.sol";

// Storage

import { WithStorage } from "../libraries/WithStorage.sol";

// Types

import { FighterBody } from "../FyteTypes.sol";

contract FyteFigther is WithStorage, ERC721 {
    /*//////////////////////////////////////////////////////////////
                               LIBRARIES
    //////////////////////////////////////////////////////////////*/

    using ERC721BaseStorage for ERC721BaseStorage.Layout;

    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event FigtherMinted(address indexed _owner, uint256 indexed _tokenId);
    event FigtherDeposited(address indexed _owner, uint256 indexed _tokenId);
    event FigtherWithdrawn(address indexed _owner, uint256 indexed _tokenId);

    /*//////////////////////////////////////////////////////////////
                               MODIFIERS
    //////////////////////////////////////////////////////////////*/

    modifier onlyOwner() {
        require(LibDiamond.contractOwner() == msg.sender, "Only Owner");
        _;
    }

    /*//////////////////////////////////////////////////////////////
                                EXTERNAL
    //////////////////////////////////////////////////////////////*/

    function mintFighter() public payable {
        require(msg.value >= 0.01 ether, "Not enough Ether");
    }

    /*//////////////////////////////////////////////////////////////
                                 PUBLIC
    //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
                                INTERNAL
    //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
                                PRIVATE
    //////////////////////////////////////////////////////////////*/
}
