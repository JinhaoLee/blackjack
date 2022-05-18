// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Card {
    // Vars 
    enum suits {
        spades, 
        clubs,
        hearts,
        diamonds
    }

    enum ranks {
        ace,jack,queen, king
    }

    // constructor
    constructor(string _suit, string _rank) {
        suit = _suit;
        rank = _rank;
    }

    // get value of a card
    function getValue() public view returns (uint value) {
        if                 
    }
}

contract Deck is Card {
    // Vars 

    // constructor
    constructor() {
    }


}