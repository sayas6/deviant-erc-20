const DeviantCoin = artifacts.require("./DeviantCoin.sol");

module.exports = function (deployer) {
  deployer.deploy(DeviantCoin);
};

/* module.exports = function(deployer, network, account) {
  if(network == 'bsctestnet') {
    await deployer.deploye(DeviantCoin);
    const wDev = DeviantCoin.devpoyed();
  } else {
    
  }
} */
