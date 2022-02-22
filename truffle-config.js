const HDWalletProvider = require('@truffle/hdwallet-provider');
// const fs = require('fs');

const mnemonic = require("./secrets.json").mnemonic

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",     // Localhost (default: none)
      port: 8545,            // Standard BSC port (default: none)
      network_id: "*",       // Any network (default: none)
    },

    // BSC NETWORK

    testnet: {
      provider: () => new HDWalletProvider(mnemonic, "https://speedy-nodes-nyc.moralis.io/d62d14d8b5a461512153716c/bsc/testnet"),
      network_id: 97,
      // from: "0x5D343718aB4D446BaC63CE2f26E56f148d9Cbd65",
      // from: "0x8C69D022dB0bdA226aF547cA5a16f0dE21C01154", // metamask account address
      // from: "0x6b4b69e473754a3d14E1F7be985c5a5c7CB68Be4", // binance wallet account address
      // gas: 8500000,           // Gas sent with each transaction (default: ~6700000)
      // gasPrice: 20000000000,
      confirmations: 2,
      // skipDryRun: true,
      websocket: true,
      // timeoutBlocks: 100000,
      networkCheckTimeout: 50000000
    },

    mainnet: {
      provider: () => new HDWalletProvider(mnemonic, `https://bsc-dataseed1.binance.org`),
      network_id: 56,
      confirmations: 10,
      timeoutBlocks: 200,
      skipDryRun: true
    },

    // ETHEREUM NETWORK

    ganache: {
      // provider: () => new HDWalletProvider(mnemonic, "https://localhost:7545"),
      host: "localhost",
      port: 7545, 
      network_id: 5777,
    }

  },

  // Set default mocha options here, use special reporters etc.
  mocha: {
    // timeout: 100000
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: "^0.5.11", // A version or constraint - Ex. "^0.5.0"
    }
  }
}