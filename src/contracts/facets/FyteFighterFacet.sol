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

import { FighterBody, FighterMintArgs, Fighter, Move } from "../FyteTypes.sol";

contract FyteFighterFacet is WithStorage, ERC721 {
    /*//////////////////////////////////////////////////////////////
                               LIBRARIES
    //////////////////////////////////////////////////////////////*/

    using ERC721BaseStorage for ERC721BaseStorage.Layout;

    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event FighterMinted(address indexed _owner, uint256 indexed _tokenId);

    /*//////////////////////////////////////////////////////////////
                               MODIFIERS
    //////////////////////////////////////////////////////////////*/

    modifier onlyOwner() {
        require(LibDiamond.contractOwner() == msg.sender, "Only Owner"); // TODO: export modifiers to shared lib
        _;
    }

    modifier notPaused() {
        require(!gs().paused, "Paused");
        _;
    }

    modifier costSetup(FighterBody body) {
        require(gs().fighterMintCosts[body] > 0, "Cost not setup");
        _;
    }

    /*//////////////////////////////////////////////////////////////
                                EXTERNAL
    //////////////////////////////////////////////////////////////*/

    function mintFighter(FighterMintArgs memory args) external payable notPaused costSetup(args.body) {
        require(msg.value >= gs().fighterMintCosts[args.body], "Insufficient funds to mint fighter");
        _mintFighter(args);
    }

    /*//////////////////////////////////////////////////////////////
                                 PUBLIC
    //////////////////////////////////////////////////////////////*/

    function getFighter(uint256 tokenId) public view returns (Fighter memory) {
        require(_exists(tokenId), "Fighter does not exist");
        return gs().fighters[tokenId];
    }

    function getPlayerFighters(address owner) public view returns (Fighter[] memory) {
        uint256 balance = _balanceOf(owner);
        Fighter[] memory fighters = new Fighter[](balance);

        for (uint256 i; i < balance;) {
            uint256 tokenId = tokenOfOwnerByIndex(owner, i);
            fighters[i] = getFighter(tokenId);
            unchecked {
                ++i;
            }
        }

        return fighters;
    }

    function setMintCost(FighterBody body, uint256 cost) public onlyOwner {
        gs().fighterMintCosts[body] = cost;
    }

    function getMintCost(FighterBody body) public view returns (uint256) {
        return gs().fighterMintCosts[body];
    }

    /*//////////////////////////////////////////////////////////////
                                INTERNAL
    //////////////////////////////////////////////////////////////*/

    function _mintFighter(FighterMintArgs memory args) internal {
        uint256 tokenId = _totalSupply() + 1;

        Move[8] memory moves = _getBodyMoves(args.body);

        gs().fighters[tokenId].id = tokenId;
        gs().fighters[tokenId].body = args.body;

        for (uint8 i; i < moves.length;) {
            gs().fighters[tokenId].moves[i] = moves[i];
            unchecked {
                ++i;
            }
        }

        _mint(args.owner, tokenId);
        emit FighterMinted(args.owner, tokenId);
    }

    /*//////////////////////////////////////////////////////////////
                                PRIVATE
    //////////////////////////////////////////////////////////////*/

    function _getBodyMoves(FighterBody) private pure returns (Move[8] memory moves) {
        // TO:DO -> CUSTOMIZE MOVES
        // random moves for now
        for (uint256 i; i < 8;) {
            moves[i] = Move(uint8(i), uint8(i), uint128(i), uint128(i), uint128(i));
            unchecked {
                ++i;
            }
        }
        return moves;
    }
}
