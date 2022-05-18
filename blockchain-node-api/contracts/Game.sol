// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// import "./Deck.sol";

contract Game {
    // Game info 
    mapping (address => uint) internal points;
    mapping (address => uint) internal deposits;
    mapping (address => uint) internal bets;
    mapping (address => bool) internal isStand;
    // mapping (address => bool) internal isDouble;
    uint internal lastJoin;
    uint internal playerNum;
    bool internal isStart;
    bool internal debug;

    // debugging events
    event blockNum(uint value);
    event add(address addr);
    event dp(uint value);
    event bt(uint value);

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

        debug= true;
    }

    // game has started
    modifier gameStarted() {
        require(isStart, "Sorry, the game hasnt started yet.");
        _;
    }

    // game has not started 
    modifier gameNotStarted() {
        require(!isStart, "Sorry, the game has started.");
        _;
    }

    // player has not stand yet
    modifier notStand() {
        require(!isStand[msg.sender], "You have standed");
        _;
    }

    // **** make sure modify the function to view ****   get time 
    function getTime() private returns(uint time) {
        if (debug) {emit blockNum(block.number); }
        return block.number;
    }

    // JoinGame - allows players to join an existing game
    function joinGame (address addr, uint deposit, uint bet) public gameNotStarted {
        require(deposit >= 2 * bet && playerNum < 5);    // make sure deposit is greater than bet

        if (debug) {
            emit blockNum(block.number); 
            emit add(addr);
            emit dp(deposit);
            emit bt(bet);
            }

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
    function endGame() view private gameStarted {
        /*  TODO
            1. only the dealer can call this function (properly work)
            2. need to check all players have standed the game
            3. might need to call withdraw as the game has ended.
        */
    }

    // stand - allows a player to stand 
    function stand() public gameStarted notStand {
        isStand[msg.sender] = true;
        // TODO: need to add more attackers resistance cases 
    }

    // hit - allows a player to hit
    function hit() public gameStarted notStand {
        /* TODO
            1. randomly draw one card from the deck (consider shuffle the deck)
            2. update player points
        */
    }

    // doubleDown - allows a player to double down
    function doubleDown() public payable gameStarted notStand {
        require(msg.value >= bets[msg.sender]); // double down ***** ? use == to restrict the value
        hit();
        stand();
    }

    // reveal - the dealer reveals the card on hand
    function reveal() public gameStarted {
        /* TODO
            1. dealer reveal the hidden card
            2. calculate the points dealer has on hand
            3. call another function to end the game (with conditions)
        */ 
    }

    // getPoints - returns the points of a player or dealer ----------DONE
    function getPoints(address addr) public view returns (uint value) {
        return points[addr];
    }

    // withdraw - dealer or playes can withdraw money 
    function withdraw() public payable {
        /* TODO
            1. refund money iff something bad happened
            2. allow winners to withdraw their money
            3. re-entency attack
        */
    }

    function balckJack() private gameStarted returns (bool isWin) {
        /* TODO
            1. conditions and cards
            2. modify the winner
            3. return bool
        */
    }
}
