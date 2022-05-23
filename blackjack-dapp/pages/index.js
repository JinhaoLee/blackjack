import Head from "next/head";
import Web3 from "web3";
import { useState, useEffect } from "react";
import blackjackContract from "../blockchain/blackjack";
import "bootstrap/dist/css/bootstrap.css";
// import styles from '../styles/Home.module.css'

export default function Home() {
  const [web3, setWeb3] = useState();
  const [contract, setContract] = useState();
  const [address, setAddress] = useState("");
  const [bet, setBet] = useState(0);
  const [deposit , setDeposit] = useState(0);
  const [playerHand, setPlayerHand] = useState([]);
  const [dealerHand, setDealerHand] = useState([]);
  const [gameStarted, setGameStarted] = useState(false);
  const [gameOver, setGameOver] = useState(false);

  const [playerScore, setPlayerScore] = useState(0);
  const [dealerScore, setDealerScore] = useState(0);

  const [balance, setBalance] = useState(0);

  const contractAddress = "0xf1e018C4F604D3063b5B31a2F500b77F348D5fEc";
  const cards = ['A',2,3,4,5,6,7,8,9,10,'J','Q','K'];
  const suits = ['♦','♣','♥','♠'];
  
  useEffect(() => {
    async function fetchMyAPI() {
      if (window.ethereum) {
        const provider = new Web3.providers.HttpProvider('http://localhost:7545');
        var web3 = new Web3(provider);
        setWeb3(web3);
  
        // create local contract instance
        const ctr = blackjackContract(web3);
        setContract(ctr);

        console.log('connect to web3');
      } else {
        alert("install metamask extension!");
      }
    }
    fetchMyAPI()
  }, [])

  useEffect(() => {
    async function calScore(){
      try {
        setPlayerScore(await contract.methods.getPoints(address).call());
        setDealerScore(await contract.methods.getPoints(contractAddress).call());
        
        const bal = await web3.eth.getBalance(address);
        setBalance(web3.utils.fromWei(bal, 'ether'));
        
        // console.log(await contract.methods.getDeck().call());
      } catch(err){
        console.log(err)
      }
    };
    calScore();
  }, [playerHand, dealerHand])

  const joinGame = async () => {
    // console.log(address);
    // console.log(bet);
    // console.log(deposit);
    
    const value = parseInt(bet) + parseInt(deposit);
    // try {
    
    await contract.methods.joinGame(deposit, bet).send({ 
      from: address,
      value: value,
      gas: 3000000,
      gasPrice: null
    });

    setGameStarted(await contract.methods.isGameStarted().call());
    setPlayerHand(await getHand(address));
    setDealerHand(await getHand(contractAddress));
    // setPlayerScore(await contract.methods.getPoints(address).call());
    // setDealerScore(await contract.methods.getPoints(contractAddress).call());

    // } catch (e) {
    //     const data = e.data;
    //     const txHash = Object.keys(data)[0]; // TODO improve
    //     const reason = data[txHash].reason;
    //     console.log(reason); // prints "This is error message"
    //     // pop up reason
    //     window.alert(reason);
    // }
  }

  const hitHandle = async () => {
    await contract.methods.hit().send({
      from: address,
      gas: 3000000,
      gasPrice: null
    });

    setPlayerHand(await getHand(address));
    setDealerHand(await getHand(contractAddress));
    setGameStarted(await contract.methods.isGameStarted().call());
    setGameOver(await contract.methods.isGameEnded().call());
  }

  const getHand = async (address) => {
    const hand = await contract.methods.getHand().call({
      from: address,
      gas: 300000,
      gasPrice: null
    });

    return hand;
  }

  const standHandle = async () => {
    await contract.methods.stand().send({
      from: address,
      gas: 300000,
      gasPrice: null
    });

    setPlayerHand(await getHand(address));
    setDealerHand(await getHand(contractAddress));
    setGameStarted(await contract.methods.isGameStarted().call());
    setGameOver(await contract.methods.isGameEnded().call());
  }

  const doubleHandle = async () => {
    await contract.methods.doubleDown().send({
      from: address,
      value: parseInt(bet),
      gas: 300000,
      gasPrice: null
    });

    setPlayerHand(await getHand(address));
    setDealerHand(await getHand(contractAddress));
    setGameStarted(await contract.methods.isGameStarted().call());
    setGameOver(await contract.methods.isGameEnded().call());
  }

  const withdrawHandle = async () => {
    await contract.methods.withdraw().send({
      from: address,
      gas: 3000000,
      gasPrice: null
    })

    setGameStarted(await contract.methods.isGameStarted().call());
    setGameOver(await contract.methods.isGameEnded().call());
    setPlayerHand([]);
    setDealerHand([]);
  }

  const getCard = (card) => {
    const num = parseInt(card);
    const suit = suits[Math.trunc(num / 14)];
    const value = cards[(num-1) % 13];

    return {
      suit: suit,
      value: value
    }
  }

  return (
    <div>
      <Head>
        <title>Blackjack</title>
        <meta name="description" content="An Ethereum Blackjack Dapp" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className="container">
        <div className="row mt-3 text-center">
          <div className="col-12">
            <h1>Blackjack</h1>
            <p>An Ethereum Blackjack Dapp</p>
          </div>
        </div>
        
        <div className="row">
          <div className="col-md-2"/>
          <div className="col-md-4 mb-3">
            <label htmlFor="inputEmail4">Address</label>
            <input type="text" className="form-control" id="inputEmail4" placeholder="Address" value={address} onChange={e => setAddress(e.target.value)} disabled={gameStarted}/>
          </div>
          <div className="col-md mb-3">
            <label htmlFor="deposit">Deposit</label>
            <input type="text" className="form-control" id="deposit" placeholder="Deposit" value={deposit} onChange={e => setDeposit(e.target.value)} disabled={gameStarted}/>
          </div>
          <div className="col-md mb-3">
            <label htmlFor="bet">Bet</label>
            <input type="text" className="form-control" id="bet" placeholder="Bet" value={bet} onChange={e => setBet(e.target.value)} disabled={gameStarted}/>
          </div>
          <div className="col-md-2">
            <label htmlFor="join-game"></label>
            <button className="btn btn-outline-secondary d-flex" type="submit" id="join-game" onClick={joinGame} disabled={gameStarted}>Join Game</button>
          </div>
        </div>

        <div className="row">
          <div className="col-md-12 text-center">
            <div className="btn-group">
            <button className="btn btn-outline-secondary" type="submit" id="hit" onClick={hitHandle} disabled={gameOver}>Hit</button>
            <button className="btn btn-outline-secondary" type="submit" id="stand" onClick={standHandle} disabled={gameOver}>Stand</button>
            <button className="btn btn-outline-secondary" type="submit" id="double-down" onClick={doubleHandle} disabled={gameOver}>Double Down</button>
            <button className="btn btn-outline-secondary" type="submit" id="hit" onClick={withdrawHandle} disabled={!gameOver}>Withdraw</button>
            </div>
          </div>
        </div>

        <div className="row mt-4">
          <div className="col-md"/>
          <div className="col-md-3 text-center">
            <h4>Player hand</h4>
            {playerHand.map((card, i) => {
              const cardObj = getCard(card);
              return <div className="card mt-2" key={i} style={{height: '100px'}}>{cardObj.suit} {cardObj.value}</div>;
            })}

            <h4>Dealer hand</h4>
            {dealerHand.map((card, i) => {
              const cardObj = getCard(card);
              return <div className="card mt-2" key={i} style={{height: '100px'}}>{cardObj.suit} {cardObj.value}</div>;
            })}

            <h5>Game started: {gameStarted ? "yes": "no"}</h5>
            <h5>Game ended: {gameOver ? "yes": "no"}</h5>
            <h5>Player Score: {playerScore}</h5>
            <h5>Dealer Score: {dealerScore}</h5>
            <h5>Player Balance: {balance}</h5>
          </div>
          <div className="col-md"/>
        </div>
      </main>
    </div>
  );
}
