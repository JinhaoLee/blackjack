# blackjack

In blackjack folder, this is for contract deployment. 

Please set up Ganache locally, and in truffle.config, make sure host and port are both correct (HTTP://127.0.0.1:7545).

Put your contracts in contracts folder and remember to add more migration files for your new contracts.

Run the following code to deploy your contracts:

Note that the contract addresses should be saved since they will be used in the next step.

```
truffle migrate --network development
```

In blackjack-dapp run

```
yarn install
npm run compile
yarn dev
```