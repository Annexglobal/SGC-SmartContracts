var HDWalletProvider = require("truffle-hdwallet-provider")
var NonceTrackerSubprovider = require("web3-provider-engine/subproviders/nonce-tracker")

module.exports = {
  networks: {
    mainnet: {
    network_id: "1",
      provider: function () {
        var wallet = new HDWalletProvider('Enter_your_mnemonics', 'https://mainnet.infura.io')
        var nonceTracker = new NonceTrackerSubprovider()
        wallet.engine._providers.unshift(nonceTracker)
        nonceTracker.setEngine(wallet.engine)
        return wallet
      }
    },
    rinkeby: {
    network_id: "4",
      provider: function () {
        var wallet = new HDWalletProvider('Enter_your_mnemonics', 'https://rinkeby.infura.io')
        var nonceTracker = new NonceTrackerSubprovider()
        wallet.engine._providers.unshift(nonceTracker)
        nonceTracker.setEngine(wallet.engine)
        return wallet
      }
    }
  }
}