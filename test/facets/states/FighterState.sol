// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

// solhint-disable
import "src/contracts/dependencies/interfaces/IDiamondCut.sol";
import "src/contracts/dependencies/facets/DiamondCutFacet.sol";
import "src/contracts/dependencies/facets/DiamondLoupeFacet.sol";
import "src/contracts/dependencies/facets/OwnershipFacet.sol";
import "src/contracts/dependencies/Diamond.sol";
import "src/contracts/facets/FyteFighterFacet.sol";
import "../../diamond/util/HelperContract.sol";
import "../../diamond/util/DiamondState.sol";

abstract contract StateFighterFacet is StateDeployDiamond {
    FyteFighterFacet fighterFacet;

    function setUp() public virtual override {
        super.setUp();

        //deploy fighterFacet
        fighterFacet = new FyteFighterFacet();

        // get functions selectors but remove (supportsInterface)
        bytes4[] memory fromGenSelectors = removeSupportsInterface(generateSelectors("FyteFighterFacet"));

        // array of functions to add
        FacetCut[] memory facetCut = new FacetCut[](1);
        facetCut[0] = FacetCut({
            facetAddress: address(fighterFacet),
            action: FacetCutAction.Add,
            functionSelectors: fromGenSelectors
        });

        // add functions to diamond
        ICut.diamondCut(facetCut, address(0x0), "");
    }
}
