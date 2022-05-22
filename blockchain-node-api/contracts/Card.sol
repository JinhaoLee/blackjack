// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Card {
    // Vars 
    // enum suits {
    //     spades, 
    //     clubs,
    //     hearts,
    //     diamonds
    // }

    uint public suit;
    uint public rank;

    // constructor
    constructor(uint _suit, uint _rank) {
        suit = _suit;
        rank = _rank;
    }

    // get value of a card
    function getValue() public view returns (uint value) {
        if ( rank <= 10 ) { return rank; }
        else { return 10; }
    }

    function getSuit() public view returns (uint){
        return suit;
    }
}

/* TODO
    1. complet deck class 
    2. add more test cases
*/
contract Deck {
    Card card;
    Card[] public cards;

    // constructor
    constructor() {
        for (uint i=1; i<=4; i++){
            for(uint j=1; j<=13; j++){
                card = new Card(i,j);
                cards.push(card);
            }
        }
    }

    function shuffle() public {
        // Shuffle the cards in a deck
    }

    function drawOne() public view returns (Card) {
        // get a card from a card list
        // TODO !!!! Need to update the deck list **** Not correct at the moment
        return cards[0];
    }
}