require("@nomiclabs/hardhat-ethers");
const privateKey =
  "06b2ca722441fc7ce6bb61c66aae0f928eb4012f9c03d89100e19396349510dc";
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
