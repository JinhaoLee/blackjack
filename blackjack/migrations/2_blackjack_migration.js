const Blackjack = artifacts.require("Blackjack");

module.exports = function (deployer) {
  deployer.deploy(Blackjack);
};
