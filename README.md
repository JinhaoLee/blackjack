# blackjack

In blackjack folder, this is for contract development and deployment. 

Please set up any Ethereum blockchain testnet, such as Ganache, and in truffle.config, make sure configuration is correct.

Put your contracts in contracts folder and remember to add more migration files for your new contracts.

Run the following code to deploy your contracts:

Note that the contract addresses should be saved since they will be used in the next step.

```
truffle migrate --network ganache
```

# blackjack-dapp

In blackjack-dapp run, remember to set the contract addresses in the index.js and blackjack.js file.

Also run the following codes to set up environment and run the front-end server.

```
yarn install
yarn dev
```

Video link: https://youtu.be/jJdFZ0y-4Tg