require("@nomiclabs/hardhat-ethers");
require("dotenv");

const privateKey = process.env.PRIVATE_KEY;
module.exports = {
  defaultNetwork: "aurora",
  networks: {
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
