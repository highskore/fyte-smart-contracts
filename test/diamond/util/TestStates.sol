// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

/**
 * \
 * Authors: Timo Neumann <timo@fyde.fi>, Rohan Sundar <rohan@fyde.fi>
 * EIP-2535 Diamonds: https://eips.ethereum.org/EIPS/eip-2535
 * Abstract Contracts for the shared setup of the tests
 * /*****************************************************************************
 */
//solhint-disable
import "src/contracts/dependencies/interfaces/IDiamondCut.sol";
import "src/contracts/dependencies/facets/DiamondCutFacet.sol";
import "src/contracts/dependencies/facets/DiamondLoupeFacet.sol";
import "src/contracts/dependencies/facets/OwnershipFacet.sol";
import "src/contracts/dependencies/Diamond.sol";
import "./HelperContract.sol";

abstract contract StateDeployDiamond is HelperContract {
    //contract types of facets to be deployed
    Diamond diamond;
    DiamondCutFacet dCutFacet;
    DiamondLoupeFacet dLoupe;
    OwnershipFacet ownerF;

    //interfaces with Facet ABI connected to diamond address
    IDiamondLoupe ILoupe;
    IDiamondCut ICut;

    string[] facetNames;
    address[] facetAddressList;

    // deploys diamond and connects facets
    function setUp() public virtual {
        //deploy facets
        dCutFacet = new DiamondCutFacet();
        dLoupe = new DiamondLoupeFacet();
        ownerF = new OwnershipFacet();
        facetNames = ["DiamondCutFacet", "DiamondLoupeFacet", "OwnershipFacet"];

        // diamod arguments
        DiamondArgs memory _args = DiamondArgs({ owner: address(this), init: address(0), initCalldata: " " });

        // FacetCut with CutFacet for initialisation
        FacetCut[] memory cut0 = new FacetCut[](1);
        cut0[0] = FacetCut({
            facetAddress: address(dCutFacet),
            action: IDiamond.FacetCutAction.Add,
            functionSelectors: generateSelectors("DiamondCutFacet")
        });

        // deploy diamond
        diamond = new Diamond(cut0, _args);

        //upgrade diamond with facets

        //build cut struct
        FacetCut[] memory cut = new FacetCut[](2);

        cut[0] = (
            FacetCut({
                facetAddress: address(dLoupe),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("DiamondLoupeFacet")
            })
        );

        cut[1] = (
            FacetCut({
                facetAddress: address(ownerF),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("OwnershipFacet")
            })
        );

        // initialise interfaces
        ILoupe = IDiamondLoupe(address(diamond));
        ICut = IDiamondCut(address(diamond));

        //upgrade diamond
        ICut.diamondCut(cut, address(0x0), "");

        // get all addresses
        facetAddressList = ILoupe.facetAddresses();
    }
}
