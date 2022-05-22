const blackjackApi = [{"inputs":[],"stateMutability":"payable","type":"constructor"},{"inputs":[],"name":"deposit","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[],"name":"notPayable","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address payable","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address payable","name":"_to","type":"address"},{"internalType":"uint256","name":"_amount","type":"uint256"}],"name":"transfer","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"withdraw","outputs":[],"stateMutability":"nonpayable","type":"function"}];

const blackjackContract = web3 => {
    return new web3.eth.Contract(
        blackjackApi, 
        '0x69F7D62C186763fDf747fA56B83c08c7Bf262416'
        // '0x0CeeCb07d75dFD3B1d332d44610c5D93cdf4af42'
    )
}

export default blackjackContract;