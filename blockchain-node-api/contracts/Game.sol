// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// import "./Deck.sol";

contract Game {
    // Game info 
    mapping (address => uint) internal points;
    mapping (address => uint) internal deposits;
    mapping (address => uint) internal bets;
    mapping (address => bool) internal isStand;
    uint lastJoin;
    uint playerNum;
    bool isStart;
    // Deck deck;

    // constructor
    constructor(address _playerAddress, uint _deposit, uint _bet) {
        points[_playerAddress] = 0;
        deposits[_playerAddress] = _deposit;
        bets[_playerAddress] = _bet;
        isStand[_playerAddress] = false;
        lastJoin = getTime();
        isStart = false;
        playerNum = 1;
    }

    // getTime 
    function getTime() private view returns(uint time) {
        return block.number;
    }

    // JoinGame - allows players to join an existing game
    function joinGame (address addr, uint deposit, uint bet) public {
        require(!isStart, "Sorry, the game has started.");  // Game hasnt started
        require(deposit >= 2 * bet && playerNum < 5);    // make sure deposit is greater than bet
        points[addr] = 0;
        deposits[addr] = deposit;
        bets[addr] = bet;
        playerNum ++;
        lastJoin = getTime();   // update last join time
    }

    // startGame - allows the dealer to start the game after someone joined
    function startGame () public {
        require(!isStart, "The game has started.");
        require( getTime() - lastJoin == 3, "Wait until more players join the game.");
        while (playerNum > 0) 
        {   
            /* TODO  
            1. get the deck from the contract and random draw two card for each player
            2 .update deck and player points 
            */
            playerNum --;
        }

    }

    // endGame - allows dealer to end the game -- Can only be called by the dealer
    function endGame() private {
        require(isStart, "The Game has not started yet.");
        require(msg.sender == address(this));

    }

    // stand - allows a player to stand 
    function stand() public {

    }

    // hit - allows a player to hit
    function hit() public {

    }

    // doubleDown - allows a player to double down
    function doubleDown() public {

    }

    // reveal - the dealer reveals the card on hand
    function reveal() public {

    }

    // getPoints - returns the points of a player or dealer
    function getPoints(address addr) public view returns (uint value) {
        return points[addr];
    }

    // withdraw - dealer or playes can withdraw money 
    function withdraw() public payable {

    }

    /* TODO 
        1. Black Jack
        2. withdraw function 
        3. interface 
    */


}
