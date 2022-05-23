const blackjackApi = [{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"addr","type":"address"}],"name":"add","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"blockNum","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"bt","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"dp","type":"event"},{"inputs":[],"name":"doubleDown","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[],"name":"hit","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"deposit","type":"uint256"},{"internalType":"uint256","name":"bet","type":"uint256"}],"name":"joinGame","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[],"name":"stand","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"withdraw","outputs":[],"stateMutability":"payable","type":"function"},{"stateMutability":"payable","type":"receive"}];

const blackjackContract = web3 => {
    return new web3.eth.Contract(
        blackjackApi, 
        '0x8aAA233953091cCA8b68420ee8Ce4B1022BEAd57'
    )
}

export default blackjackContract;