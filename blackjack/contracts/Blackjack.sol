// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract Game {
    // Game info 
    mapping (address => uint) private deposits;
    mapping (address => uint) private bets;
    mapping (address => bool) private isStand;
    mapping (address => uint[]) private hands;

    // uint private lastJoin;
    bool private isStart;
    bool private isEnd;
    bool private debug;
    bool private lock;

    uint[] private deck;
    address private dealer;
    address payable[] private players;
    
    uint constant DEALER_MIN_POINTS = 17;
    uint constant MAX_POINTS = 21;
    
    // debugging events
    event blockNum(uint value);
    event add(address addr);
    event dp(uint value);
    event bt(uint value);

    constructor() {
        dealer = address(this);
        initGame();
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

    modifier GameEnded(){
        require(isEnd, "Game is not ended");
        _;
    }

    modifier areAllPlayersStand() {
        for (uint i=0; i<players.length; i++){
            require(isStand[players[i]], "There is a player not standed");
        }
        _;
    }

    modifier isPlayer() {
        require(deposits[msg.sender] != 0, "You are not a player");
        _;
    }

    modifier notReEntrancy() {
        require(!lock, "can't re-entry attack");
        lock = true;
        _;
        lock = false;
    }

    // **** make sure modify the function to view ****  
    // function getTime() private returns(uint time) {
    //     if (debug) {emit blockNum(block.number); }
    //     return block.number;
    // }

    // JoinGame - allows players to join an existing game
    function joinGame(uint deposit, uint bet) public payable gameNotStarted {
        require(deposit >= 2 * bet && getPlayerNum() <= 5, "make sure deposit is two times larger than bet");    // make sure deposit is greater than bet
        require(deposit + bet == msg.value, "deposit plus bet is not equal to your value");
        players.push(payable(msg.sender));    // add player to the players (payable)

        deposits[msg.sender] = deposit;
        bets[msg.sender] = bet;
        // lastJoin = getTime();   // update last join time

        // start the game if this is the first player
        if (getPlayerNum() == 1) {
            startGame();
        }
    }

    // startGame - allows the dealer to start the game after someone joined
    function startGame() private gameNotStarted {
        require(getPlayerNum() > 0, "Not enough players");
        // require(getTime() - lastJoin == 3, "Wait until more players join the game.");

        // draw one card for dealder
        hands[dealer].push(drawOne());

        for (uint i=0; i < getPlayerNum(); i++)
        {   
            /* TODO  
            1. get the deck from the contract and random draw two card for each player
            2 .update deck and player points 
            */
            hands[msg.sender].push(drawOne());
            hands[msg.sender].push(drawOne());
        }

        isStart = true;
    }

    function drawOne() private returns (uint) {
        uint temp = deck[deck.length - 1];
        deck.pop();
        return temp;
    }

    // endGame - allows dealer to end the game -- Can only be called by the dealer
    function endGame() private gameStarted areAllPlayersStand {
        /*  TODO
            1. only the dealer can call this function (properly work)
            2. need to check all players have standed the game
            3. might need to call withdraw as the game has ended.
        */
        isEnd = true;

        hands[dealer].push(drawOne());
        uint dealerPoints = getPoints(dealer);
        
        // draw cards until 17 points
        while (dealerPoints < DEALER_MIN_POINTS) {
            hands[dealer].push(drawOne());
            dealerPoints = getPoints(dealer);
        }

        // if dealer bust, then all players win
        if (dealerPoints > MAX_POINTS) {
            for (uint i=0; i < getPlayerNum(); i++) {
                uint playerPoints = getPoints(players[i]);
                if (playerPoints > MAX_POINTS) {
                    bets[players[i]] = 0;
                }
            }
        } else {
            for (uint i=0; i < getPlayerNum(); i++)
            {
                uint playerPoints = getPoints(players[i]);
                if (playerPoints < dealerPoints || playerPoints > MAX_POINTS) {
                    // player lose
                    bets[players[i]] = 0;
                } else if (playerPoints == dealerPoints) {
                    // tie
                    bets[players[i]] = bets[players[i]] / 2;
                }
            }
        }
    }

    // stand - allows a player to stand 
    function stand() public gameStarted notStand isPlayer {
        isStand[msg.sender] = true;

        bool allStand = true;
        for(uint i = 0; i < getPlayerNum(); i++) {
            if (!isStand[players[i]]) {
                allStand = false;
            }
        }

        if (allStand) {
            endGame();
        }
    }

    // hit - allows a player to hit
    function hit() public gameStarted notStand isPlayer {
        /* TODO
            1. randomly draw one card from the deck (consider shuffle the deck)
            2. update player points
        */
        hands[msg.sender].push(drawOne());
    }

    // doubleDown - allows a player to double down
    function doubleDown() public payable gameStarted notStand isPlayer {
        require(msg.value == bets[msg.sender], "should match the previous bet"); // double down ***** ? use == to restrict the value
        bets[msg.sender] = 2 * bets[msg.sender];
        hit();
        stand();
    }


    // getPoints - returns the points of a player or dealer ----------DONE
    function getPoints(address addr) private view returns (uint value) {
        uint[] memory hand = hands[addr];
        uint points = 0;
        for (uint i=0; i<hand.length; i++) {
            points += getCardPoints(hand[i]);
        }
        return points;
    }

    function getCardPoints(uint card) private pure returns (uint value) {
        uint points = card % 13;
        if (points >= 10) {
            return 10;
        } 
        return points;
    }

    // withdraw - dealer or playes can withdraw money 
    function withdraw() public payable notReEntrancy GameEnded isPlayer {
        /* TODO
            1. refund money iff something bad happened
            2. allow winners to withdraw their money
            3. re-entency attack
        */
        uint desposit = deposits[msg.sender];
        deposits[msg.sender] = 0;
        (bool despositSuccess, ) = msg.sender.call{value:desposit}("");
        require(despositSuccess, "Deposit refund failed.");

        uint bet = bets[msg.sender];
        bets[msg.sender] = 0;
        (bool betSuccess, ) = msg.sender.call{value: bet*2}("");
        require(betSuccess, "Bet refund failed.");

        reset();
    }

    function reset() private {
        bool canReset = true;

        for (uint i = 0; i < getPlayerNum(); i++) {
            if (deposits[players[i]] != 0) {
                canReset = false;
            } else {
                address player = players[i];
                isStand[player] = false;
                hands[player] = new uint[](0);
            }
        }

        if (canReset) {
            initGame();
        } 
    }

    function initGame() private {
        players = new address payable[](0);
        deck = new uint[](0);

        for(uint i=1; i<=52; i++){
            deck.push(i);
        }

        // lastJoin = getTime();
        isStart = false;
        isEnd = false;
        debug= true;
    }

    // Black Jack
    function blackJack() private gameStarted returns (bool isWin) {
        /* TODO
            1. conditions and cards
            2. modify the winner
            3. return bool
        */
    }

    // get length of a list
    function getPlayerNum() private view returns(uint) {  
        return players.length;
    } 

    //can receive money
    receive() external payable {}
}