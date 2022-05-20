// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./TestFramework.sol";
import "./Bidders.sol";

contract SimpleGame is Game {

    // constructor
    constructor(address _playerAddress,
                uint _deposit, 
                uint _bet) payable
             Game (_playerAddress, _deposit, _bet) {
    }
    //can receive money
    receive() external payable {}
}

contract GameTest {

    SimpleGame testGame;

    // Adjust this to change the test code's initial balance
    uint public initialBalance = 1000000000 wei;
    Participant dealer;
    Participant player1;
    Participant player2;
    Participant player3;

    //can receive money
    receive() external payable {}
    constructor() payable {}

    function setupContracts() public {
        dealer  = new Participant(Auction(address(0)));
        player1 = new Participant(Auction(address(0)));
        player2 = new Participant(Auction(address(0)));
        player3 = new Participant(Auction(address(0)));

        testGame = new SimpleGame(address(player1), 1000, 100);

        payable(testGame).transfer(100 wei);

        dealer.setGame(testGame);
        player1.setGame(testGame);
        player2.setGame(testGame);
        player3.setGame(testGame);
    }

    function testCreateContracts() public {
        setupContracts();
        Assert.isFalse(false, "this test should not fail");
        Assert.isTrue(true, "this test should never fail");
        Assert.equal(uint(7), uint(7), "this test should never fail");
    }

    // function testEarlyStart() public {
    //     setupContracts();
    //     Assert.isFalse(judge.callFinalize(), "finalize with no declared winner should be rejected");
    // }

}
