// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./TestFramework.sol";

contract Bidders {}

contract Participant {

    Game game;

    constructor(Game _game) {
        setGame(_game);
    }

    function setGame(Game _game) public {
        game = _game;
    }

    //wrapped call
    function hit() public returns (bool success) {
        (success, ) = address(game).call{gas:200000}(abi.encodeWithSignature("hit()"));
    }

    //wrapped call
    function join() public returns (bool success)  {
        (success, ) = address(game).call{gas:200000}(abi.encodeWithSignature("joinGame()"));
    }

    //wrapped call
    function stand() public returns (bool success)  {
        (success, ) = address(game).call{gas:200000}(abi.encodeWithSignature("stand()"));
    }

    //wrapped call
    function doublDown() public returns (bool success)  {
        (success, ) = address(game).call{gas:200000}(abi.encodeWithSignature("doubleDown()"));
    }

    //wrapped call
    function reveal() public returns (bool success)  {
        (success, ) = address(game).call{gas:200000}(abi.encodeWithSignature("reveal()"));
    }

    //wrapped call
    function getPoints() public returns (bool success)  {
        (success, ) = address(game).call{gas:200000}(abi.encodeWithSignature("getPoints()"));
    }

    //wrapped call
    function startGame() public returns (bool success)  {
        (success, ) = address(game).call{gas:200000}(abi.encodeWithSignature("startGame()"));
    }

    //wrapped call
    function callWithdraw() public returns (bool success)  {
        (success, ) = address(game).call{gas:200000}(abi.encodeWithSignature("withdraw()"));
    }

    //can receive money
    receive() external payable {}
}
