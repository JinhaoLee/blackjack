// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../contracts/Game.sol";
import "../contracts/Card.sol";
import "truffle/Assert.sol";


// Needs to be defined or else to be here or else Truffle complains
contract TestFramework{
    //can receive money
    receive() external payable {}
}
