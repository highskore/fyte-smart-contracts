// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { StateFighterFacet } from "./states/FighterState.sol";

import { FighterBody, FighterMintArgs, Fighter, Move } from "src/contracts/FyteTypes.sol";

contract TestFighterFacet is StateFighterFacet {
    /*//////////////////////////////////////////////////////////////
                            EXPECTED EVENTS
    //////////////////////////////////////////////////////////////*/

    event FighterMinted(address indexed _owner, uint256 indexed _tokenId);

    /*//////////////////////////////////////////////////////////////
                                 FACET
    //////////////////////////////////////////////////////////////*/

    function test_addFigtherFacetFunctions() public {
        // arrange
        bytes4[] memory fromLoupeFacet = ILoupe.facetFunctionSelectors(address(fighterFacet));
        bytes4[] memory fromGenSelectors = removeSupportsInterface(generateSelectors("FyteFighterFacet"));

        // assert
        assertTrue(sameMembers(fromLoupeFacet, fromGenSelectors));
    }

    /*//////////////////////////////////////////////////////////////
                                UNIT
    //////////////////////////////////////////////////////////////*/

    //----------------------------------------------------------------//
    // setMintCost
    //----------------------------------------------------------------//

    function test_setMintCost_notOwner() public {
        // arrange
        FighterBody body = FighterBody(0);
        uint256 cost = 100;

        // act
        vm.prank(address(this));
        vm.expectRevert("Only Owner");
        fighterFacet.setMintCost(body, cost);

        // assert
        assertEq(fighterFacet.getMintCost(body), 0);
    }

    function test_setMintCost() public {
        // arrange
        FighterBody body = FighterBody(0);
        uint256 cost = 100;

        // act
        vm.prank(ownerF.owner());
        fighterFacet.setMintCost(body, cost);

        // assert
        assertEq(fighterFacet.getMintCost(body), cost);
    }

    //----------------------------------------------------------------//
    // mintFighter
    //----------------------------------------------------------------//

    function test_mintFighter_noCostSetup() public {
        // arrange
        FighterMintArgs memory args;
        args.body = FighterBody(0);
        args.owner = address(this);

        // act
        vm.expectRevert("Cost not setup");
        fighterFacet.mintFighter(args);

        // assert
        assertEq(fighterFacet.balanceOf(address(this)), 0);
    }

    function test_mintFighter_issuficientFunds() public {
        // arrange
        FighterMintArgs memory args;
        args.body = FighterBody(0);
        args.owner = address(this);

        // act
        vm.prank(ownerF.owner());
        fighterFacet.setMintCost(args.body, 100);
        vm.expectRevert("Insufficient funds to mint fighter");
        fighterFacet.mintFighter(args);

        // assert
        assertEq(fighterFacet.balanceOf(address(this)), 0);
    }

    function test_mintFighter() public {
        // arrange
        FighterMintArgs memory args;
        args.body = FighterBody(0);
        args.owner = address(this);
        vm.deal(address(this), 100);

        // act
        vm.prank(ownerF.owner());
        fighterFacet.setMintCost(args.body, 100);
        vm.expectEmit(true, true, false, false);
        emit FighterMinted(address(this), 1);
        fighterFacet.mintFighter{ value: 100 }(args);

        // assert
        assertEq(fighterFacet.balanceOf(address(this)), 1);
    }

    //----------------------------------------------------------------//
    // getFighter
    //----------------------------------------------------------------//

    function test_getFighter_missingId() public {
        // act
        vm.expectRevert("Fighter does not exist");
        this._wrapGetFigther();
    }

    // Helper function to wrap getFighter call for foundry revert testing
    function _wrapGetFigther() public view {
        fighterFacet.getFighter(1);
    }

    function test_getFighter() public {
        // arrange
        FighterMintArgs memory args;
        args.body = FighterBody(0);
        args.owner = address(this);
        vm.deal(address(this), 100);

        // act
        vm.prank(ownerF.owner());
        fighterFacet.setMintCost(args.body, 100);
        fighterFacet.mintFighter{ value: 100 }(args);
        Fighter memory fighter = fighterFacet.getFighter(1);

        // assert
        assertEq(uint256(fighter.body), uint256(args.body));
        assertEq(fighter.id, 1);
        Move[] memory moves = new Move[](8);
        for (uint256 i; i < 8;) {
            moves[i] = Move(uint8(i), uint8(i), uint128(i), uint128(i), uint128(i));

            assertEq(
                abi.encodePacked(
                    fighter.moves[i].slot,
                    fighter.moves[i].cooldown,
                    fighter.moves[i].speed,
                    fighter.moves[i].range,
                    fighter.moves[i].damage
                ),
                abi.encodePacked(moves[i].slot, moves[i].cooldown, moves[i].speed, moves[i].range, moves[i].damage)
            );

            unchecked {
                ++i;
            }
        }
    }

    //----------------------------------------------------------------//
    // getPlayerFighters
    //----------------------------------------------------------------//

    function test_getPlayerFighters_empty() public {
        // act
        Fighter[] memory fighters = fighterFacet.getPlayerFighters(address(this));

        // assert
        assertEq(fighters.length, 0);
    }

    function test_getPlayerFighters() public {
        // arrange
        FighterMintArgs memory args;
        args.body = FighterBody(0);
        args.owner = address(this);
        vm.deal(address(this), 100);

        // act
        vm.prank(ownerF.owner());
        fighterFacet.setMintCost(args.body, 100);
        fighterFacet.mintFighter{ value: 100 }(args);
        Fighter[] memory fighters = fighterFacet.getPlayerFighters(address(this));

        // assert
        assertEq(fighters.length, 1);
        assertEq(uint256(fighters[0].body), uint256(args.body));
        assertEq(fighters[0].id, 1);
        Move[] memory moves = new Move[](8);
        for (uint256 i; i < 8;) {
            moves[i] = Move(uint8(i), uint8(i), uint128(i), uint128(i), uint128(i));

            assertEq(
                abi.encodePacked(
                    fighters[0].moves[i].slot,
                    fighters[0].moves[i].cooldown,
                    fighters[0].moves[i].speed,
                    fighters[0].moves[i].range,
                    fighters[0].moves[i].damage
                ),
                abi.encodePacked(moves[i].slot, moves[i].cooldown, moves[i].speed, moves[i].range, moves[i].damage)
            );

            unchecked {
                ++i;
            }
        }
    }
}
