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
  const [count, setCount] = useState();
  
  useEffect(() => {
    // initialize count once web3 contract is loaded
    if (contract) getCount()
  }, [contract]); 

  const getCount = async () => {
    const c = await contract.methods.get().call();
    setCount(c);
  }

  const increase = async () => {
    try {
      console.log("increase 1");
      await contract.methods.inc().send({ from: account });
      await getCount();
    } catch(err) {
      console.log(err);
    }
  }

  const decrease = async () => {
    try {
      console.log('decrease 1');
      await contract.methods.dec().send({ from: account });
      await getCount();
    } catch(err) {
      console.log(err);
    }
  };

  const connectWalletHandler = async () => {
    if (window.ethereum) {
      await window.ethereum.enable();
      
      const provider = new Web3.providers.HttpProvider('http://localhost:7545');
      var web3 = new Web3(provider);
      setWeb3(web3);

      const accounts = await web3.eth.getAccounts();
      setAccount(accounts[0]); // setup the account with the first one

      // create local contract instance
      setContract(blackjackContract(web3));
    } else {
      alert("install metamask extension!!");
    }
  };

  return (
    <div className="container">
      <Head>
        <title>Blackjack</title>
        <meta name="description" content="An Ethereum Blackjack Dapp" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main>
        <div className="row">
          <div className="col-md-12">
            <h1>Blackjack</h1>
            <p>An Ethereum Blackjack Dapp</p>
          </div>
        </div>
        <div className="row">
          <div className="col-md-12">
            <p>Count: {count}</p>
          </div>
        </div>
        <div className="row">
          <div className="col-md-12">
            <button className="btn btn-primary" onClick={connectWalletHandler}>
              Connect Wallet
            </button>
          </div>
        </div>
        <div className="row mt-2">
          <div className="col-1">
            <button className="btn btn-primary" onClick={increase}>
              +
            </button>
          </div>
          <div className="col-1">
            <button className="btn btn-primary" onClick={decrease}>
              -
            </button>
          </div>
        </div>
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
