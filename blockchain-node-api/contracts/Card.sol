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
    // string public suit;
    uint public rank;

    // constructor
    constructor(uint _rank) {
        rank = _rank;
    }

    // get value of a card
    function getValue() public view returns (uint value) {
        if ( rank <= 10 ) { return rank; }
        else { return 10; }
    }
}

/* TODO
    1. complet deck class 
    2. add more test cases
*/

// contract Deck is Card {
//     // constructor
//     constructor() {

//     }
// }