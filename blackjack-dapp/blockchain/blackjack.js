const blackjackApi = [{"inputs":[],"name":"count","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"dec","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"get","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"inc","outputs":[],"stateMutability":"nonpayable","type":"function"}];

const blackjackContract = web3 => {
    return new web3.eth.Contract(
        blackjackApi, 
        '0x0CeeCb07d75dFD3B1d332d44610c5D93cdf4af42'
    )
}

export default blackjackContract;