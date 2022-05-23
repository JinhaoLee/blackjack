import Head from "next/head";
import Web3 from "web3";
import { useState, useEffect } from "react";
import blackjackContract from "../blockchain/blackjack";
import "bootstrap/dist/css/bootstrap.css";
// import styles from '../styles/Home.module.css'


export default function Home() {
  const [web3, setWeb3] = useState();
  const [account, setAccount] = useState();
  const [contract, setContract] = useState();
  // const [balance, setBalance] = useState(0);
  const [address, setAddress] = useState("");
  const [bet, setBet] = useState(0);
  const [deposit , setDeposit] = useState(0);
  
  useEffect(() => {

    async function fetchMyAPI() {
      if (window.ethereum) {
        // await window.ethereum.enable();
        
        const provider = new Web3.providers.HttpProvider('http://localhost:7545');
        var web3 = new Web3(provider);
        setWeb3(web3);
        
        // setup the account with the first one
        const accounts = await web3.eth.getAccounts();
        // console.log(accounts)
        setAccount(accounts[0]); 
  
        // create local contract instance
        setContract(blackjackContract(web3));
        console.log('connect to web3');
      } else {
        alert("install metamask extension!");
      }
    }

    fetchMyAPI()
  }, [])

  // useEffect(() => {
  //   // initialize count once web3 contract is loaded
  //   async function fetchData() {
  //     if (contract) {
  //       await getBalance();
  //     }
  //   }
  //   fetchData();
  // }, [contract]); 

  // const getBalance = async () => {
  //   const bal = await web3.eth.getBalance(account);
  //   setBalance(web3.utils.fromWei(bal, 'ether'));
  // }

  // const pay = async () => {
  //   const tx = await contract.methods.deposit().send(
  //     { 
  //       from: account,
  //       value: '15000000000000000',
  //       gas: 300000,
  //       gasPrice: null
  //     }
  //   );
  //   console.log(tx);
  //   await getBalance();
  // }

  // const withdraw = async () => {
  //   await contract.methods.withdraw().send({
  //     from: account,
  //     gas: 300000,
  //     gasPrice: null
  //   })
  //   console.log(await web3.eth.getBalance(contract.options.address));
  //   await getBalance();
  // }

  // const connectWalletHandler = async () => {
  //   if (window.ethereum) {
  //     // await window.ethereum.enable();
      
  //     const provider = new Web3.providers.HttpProvider('http://localhost:7545');
  //     var web3 = new Web3(provider);
  //     setWeb3(web3);
      
  //     // setup the account with the first one
  //     // const accounts = await web3.eth.getAccounts();
  //     // // console.log(accounts)
  //     // setAccount(accounts[0]); 

  //     // create local contract instance
  //     setContract(blackjackContract(web3));
  //   } else {
  //     alert("install metamask extension!");
  //   }
  // };

  const joinGame = async () => {
    console.log(address);
    console.log(bet);
    console.log(deposit);
    // console.log(account);
    
    try {
      await contract.methods.joinGame(deposit, bet).send({ 
        from: address,
        value: deposit + bet,
        gas: 3000000,
        gasPrice: null
      });
    } catch (e) {
        const data = e.data;
        const txHash = Object.keys(data)[0]; // TODO improve
        const reason = data[txHash].reason;
        console.log(reason); // prints "This is error message"
        // pop up reason
        window.alert(reason);
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
          {/* <div className="col-12">
            <button className="btn btn-primary" onClick={connectWalletHandler}>
              Connect Wallet
            </button>
          </div> */}
        </div>
        
        <div className="row">
          <div className="col-md-2"/>
          <div className="col-md-4 mb-3">
            <label htmlFor="inputEmail4">Address</label>
            <input type="text" className="form-control" id="inputEmail4" placeholder="Address" value={address} onChange={e => setAddress(e.target.value)}/>
          </div>
          <div className="col-md mb-3">
            <label htmlFor="deposit">Deposit</label>
            <input type="text" className="form-control" id="deposit" placeholder="Deposit" value={deposit} onChange={e => setDeposit(e.target.value)}/>
          </div>
          <div className="col-md mb-3">
            <label htmlFor="bet">Bet</label>
            <input type="text" className="form-control" id="bet" placeholder="Bet" value={bet} onChange={e => setBet(e.target.value)}/>
          </div>
          <div className="col-md-2">
            <label htmlFor="join-game"></label>
            <button className="btn btn-outline-secondary d-flex" type="submit" id="join-game" onClick={joinGame}>Join Game</button>
          </div>
        </div>

        {/* <div className="row">
          <div className="col-12">
            <h4>My Address: {account}</h4>
          </div>
        </div>
        <div className="row">
          <div className="col-12">
            <h4>My Balance: {balance} Ether</h4>
          </div>
        </div>
        <div className="row">
          <div className="col-3">
            <button className="btn btn-primary" onClick={pay}>
              Pay
            </button>
          </div>
          <div className="col-3">
            <button className="btn btn-primary" onClick={withdraw}>
              Withdraw
            </button>
          </div>
        </div> */}
      </main>

      {/* <footer className={styles.footer}>
        <a
          href="https://vercel.com?utm_source=create-next-app&utm_medium=default-template&utm_campaign=create-next-app"
          target="_blank"
          rel="noopener noreferrer"
        >
          Powered by{' '}
          <span className={styles.logo}>
            <Image src="/vercel.svg" alt="Vercel Logo" width={72} height={16} />
          </span>
        </a>
      </footer> */}
    </div>
  );
}
