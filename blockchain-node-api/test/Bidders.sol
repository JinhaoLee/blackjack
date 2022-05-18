// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./TestFramework.sol";

contract Bidders {}

contract Participant {

    Game game;

    constructor(Auction _auction) {
        setAuction(_auction);
    }

    function setAuction(Auction _auction) public {
        auction = _auction;
    }

    //wrapped call
    function callFinalize() public returns (bool success) {
        (success, ) = address(auction).call{gas:200000}(abi.encodeWithSignature("finalize()"));
    }

    //wrapped call
    function callRefund() public returns (bool success)  {
        (success, ) = address(auction).call{gas:200000}(abi.encodeWithSignature("refund()"));
    }

    //wrapped call
    function callWithdraw() public returns (bool success)  {
        (success, ) = address(auction).call{gas:200000}(abi.encodeWithSignature("withdraw()"));
    }

    //can receive money
    receive() external payable {}
}
