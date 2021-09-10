const MarketPlace = artifacts.require("NFTMarket");
const NFT = artifacts.require("NFT");

module.exports = async function(deployer){
    await deployer.deploy(MarketPlace);
    mp = await MarketPlace.deployed();
    await deployer.deploy(NFT,mp.address);
}