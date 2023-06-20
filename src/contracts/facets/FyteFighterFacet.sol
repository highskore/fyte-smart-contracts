// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Contracts

import { SolidStateERC721 as ERC721 } from "solidstate-solidity/token/ERC721/SolidStateERC721.sol";

// Libraries

import { LibDiamond } from "../dependencies/libraries/LibDiamond.sol";
import { ERC721BaseStorage } from "solidstate-solidity/token/ERC721/base/ERC721BaseStorage.sol";

// Storage

import { WithStorage } from "../libraries/WithStorage.sol";

// Types

import { FighterBody, FigtherMintArgs, Fighter, Move } from "../types/FyteTypes.sol";

contract FyteFigtherFacet is WithStorage, ERC721 {
    /*//////////////////////////////////////////////////////////////
                               LIBRARIES
    //////////////////////////////////////////////////////////////*/

    using ERC721BaseStorage for ERC721BaseStorage.Layout;

    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event FigtherMinted(address indexed _owner, uint256 indexed _tokenId);

    /*//////////////////////////////////////////////////////////////
                               MODIFIERS
    //////////////////////////////////////////////////////////////*/

    modifier onlyOwner() {
        require(LibDiamond.contractOwner() == msg.sender, "Only Owner");
        _;
    }

    modifier notPaused() {
        require(!gs().paused, "Paused");
        _;
    }

    /*//////////////////////////////////////////////////////////////
                                EXTERNAL
    //////////////////////////////////////////////////////////////*/

    function mintFighter(FigtherMintArgs memory args) external payable notPaused {
        require(msg.value >= gs().fighterMintCosts[args.body], "Isfficient funds to mint fighter");
        _mintFighter(args);
    }

    /*//////////////////////////////////////////////////////////////
                                 PUBLIC
    //////////////////////////////////////////////////////////////*/

    function getFighter(uint256 tokenId) public view returns (Fighter memory) {
        return gs().fighters[tokenId];
    }

    function getPlayerFighters(address owner) public view returns (Fighter[] memory) {
        uint256 balance = _balanceOf(owner);
        Fighter[] memory fighters = new Fighter[](balance);

        for (uint256 i; i < balance;) {
            unchecked {
                ++i;
            }
            uint256 tokenId = tokenOfOwnerByIndex(owner, i);
            fighters[i] = getFighter(tokenId);
        }

        return fighters;
    }

    /*//////////////////////////////////////////////////////////////
                                INTERNAL
    //////////////////////////////////////////////////////////////*/

    function _mintFighter(FigtherMintArgs memory args) internal {
        uint256 tokenId = _totalSupply() + 1;

        Move[8] memory moves = _getBodyMoves(args.body);

        gs().fighters[tokenId].id = tokenId;
        gs().fighters[tokenId].body = args.body;

        for (uint8 i; i < moves.length;) {
            unchecked {
                ++i;
            }
            gs().fighters[tokenId].moves[i] = moves[i];
        }

        _mint(args.owner, tokenId);
        emit FigtherMinted(args.owner, tokenId);
    }

    /*//////////////////////////////////////////////////////////////
                                PRIVATE
    //////////////////////////////////////////////////////////////*/

    function _getBodyMoves(FighterBody) private pure returns (Move[8] memory moves) {
        // TO:DO -> CUSTOMIZE MOVES
        // random moves for now
        for (uint256 i; i < 8;) {
            unchecked {
                ++i;
            }
            moves[i] = Move(uint8(i), uint8(i), uint128(i), uint128(i), uint128(i));
        }
        return moves;
    }
}
