// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

/**
 * \
 * Authors: Timo Neumann <timo@fyde.fi>, Rohan Sundar <rohan@fyde.fi>
 * EIP-2535 Diamonds: https://eips.ethereum.org/EIPS/eip-2535
 * /*****************************************************************************
 */
// solhint-disable-next-line
import "./util/TestStates.sol";

// test proper deployment of diamond
contract TestDeployDiamond is StateDeployDiamond {
    // TEST CASES

    function test1HasThreeFacets() public {
        assertEq(facetAddressList.length, 3);
    }

    function test2FacetsHaveCorrectSelectors() public {
        for (uint256 i = 0; i < facetAddressList.length; i++) {
            bytes4[] memory fromLoupeFacet = ILoupe.facetFunctionSelectors(facetAddressList[i]);
            bytes4[] memory fromGenSelectors = generateSelectors(facetNames[i]);
            assertTrue(sameMembers(fromLoupeFacet, fromGenSelectors));
        }
    }

    function test3SelectorsAssociatedWithCorrectFacet() public {
        for (uint256 i = 0; i < facetAddressList.length; i++) {
            bytes4[] memory fromGenSelectors = generateSelectors(facetNames[i]);
            for (uint256 j = 0; i < fromGenSelectors.length; i++) {
                assertEq(facetAddressList[i], ILoupe.facetAddress(fromGenSelectors[j]));
            }
        }
    }
}
