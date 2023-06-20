// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { FyteInit } from "src/contracts/FyteInit.sol";

contract FyteTest {
    FyteInit private fyte;

    function setUp() public virtual {
        fyte = new FyteInit();
        fyte.init();
    }
}
