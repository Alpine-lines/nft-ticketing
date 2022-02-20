require("@nomiclabs/hardhat-ethers");
require('dotenv').config({ path: require('find-config')('.env') })

const privateKey = process.env.PRIVATE_KEY;
module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    localhost: {
      url: "http://127.0.0.1:8545"
    },

    hardhat: {},
    testnet_aurora: {
      url: "https://testnet.aurora.dev",
      accounts: [privateKey],
      chainId: 1313161555,
      gasPrice: 1000000000,
    },
    aurora: {
      url: "https://mainnet.aurora.dev",
      accounts: [privateKey],
      chainId: 1313161554,
      gasPrice: 1000000000,
    },
    matic: {
      url: "https://polygon-mainnet.g.alchemy.com/v2/" + process.env.ACLHEMY_KEY,
      accounts: [privateKey],
    }
  },
  solidity: {
    version: "0.4.24",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
};
