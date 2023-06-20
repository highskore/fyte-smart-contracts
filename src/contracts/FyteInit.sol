// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/**
 * \
 * Author: Nick Mudge <nick@perfectabstractions.com> (https://twitter.com/mudgen)
 * EIP-2535 Diamonds: https://eips.ethereum.org/EIPS/eip-2535
 *
 * Implementation of a diamond.
 * /*****************************************************************************
 */

import { LibDiamond } from "./dependencies/libraries/LibDiamond.sol";
import { IDiamondLoupe } from "./dependencies/interfaces/IDiamondLoupe.sol";
import { IDiamondCut } from "./dependencies/interfaces/IDiamondCut.sol";
import { IERC173 } from "./dependencies/interfaces/IERC173.sol";
import { IERC165 } from "./dependencies/interfaces/IERC165.sol";

contract FyteInit {
    function init() external {
        // adding ERC165 data
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        ds.supportedInterfaces[type(IERC165).interfaceId] = true;
        ds.supportedInterfaces[type(IDiamondCut).interfaceId] = true;
        ds.supportedInterfaces[type(IDiamondLoupe).interfaceId] = true;
        ds.supportedInterfaces[type(IERC173).interfaceId] = true;
    }
}
