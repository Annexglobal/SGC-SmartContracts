
var SGCoin = artifacts.require('../contracts/SecuredGoldCoin.sol');


module.exports = function(deployer) {

    return deployer.deploy(SGCoin).then( async () => {
        const instance = await SGCoin.deployed(); 
    });

};