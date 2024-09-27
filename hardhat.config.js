require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

// Load environment variables from .env file
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY;

const FORK_FUJI = process.env.FORK_FUJI === 'true';
const FORK_MAINNET = process.env.FORK_MAINNET === 'true';
let forkingData = undefined;

if (FORK_MAINNET) {
  forkingData = {
    url: "https://api.avax.network/ext/bc/C/rpc",
  };
}
if (FORK_FUJI) {
  forkingData = {
    url: "https://api.avax-test.network/ext/bc/C/rpc",
  };
}

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.18",
  networks: {
    hardhat: {
      gasPrice: 50000000,
      chainId: !forkingData ? 43112 : undefined, // Only specify a chainId if we are not forking
      forking: forkingData,
    },
    fuji: {
      url: "https://api.avax-test.network/ext/bc/C/rpc",
      gasPrice: 50000000,
      chainId: 43113,
      accounts: [PRIVATE_KEY], // Use the private key from .env
    },
    mainnet: {
      url: "https://api.avax.network/ext/bc/C/rpc",
      gasPrice: 50000000,
      chainId: 43114,
      accounts: [PRIVATE_KEY],
    },
  },
  etherscan: {
    apiKey: ETHERSCAN_API_KEY, // Use the API key from .env
  },
};
