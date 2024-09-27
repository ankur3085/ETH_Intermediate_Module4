# DegenToken with To-Do List Smart Contract

Welcome to the **DegenToken** project! This repository contains the implementation of an ERC20-compatible smart contract, combined with a task management (To-Do List) system. This contract can be used to manage tokens and track tasks, making it ideal for blockchain-based applications that require both resource management and task tracking features.

## Project Overview

The **DegenToken** is a custom ERC20 token with the symbol `DGN` and no decimal places (tokens are represented as whole numbers). In addition to standard ERC20 functionality such as transferring and minting tokens, the contract owner can create, update, and complete tasks in a To-Do List. This project is useful for various applications, such as gamification, reward systems, or management ecosystems, where task tracking and token-based transactions are needed.

## Features

### ERC20 Token

- **Name**: Degen (`DGN`)
- **Symbol**: `DGN`
- **Decimals**: 0 (tokens are represented as whole units without fractional values)
- **Minting**: The owner can mint new tokens.
- **Burning**: Any user can burn their own tokens.
- **Transfers**: Users can transfer tokens to others.

### To-Do List

- **Add Tasks**: The owner can add tasks to the To-Do List.
- **Update Tasks**: The owner can update the description of existing tasks.
- **Mark Tasks as Completed**: The owner can mark tasks as completed.
- **View Tasks**: Users can view all tasks or retrieve specific tasks by ID.

## Contract Details

### Constructor

The contract is initialized as follows:

```solidity
constructor() {
    owner = msg.sender;
    totalSupply = 0;
}
```

- **Owner**: The deployer of the contract is assigned as the owner, who holds exclusive privileges to mint tokens and manage tasks.
- **Total Supply**: Initially set to zero, but can be increased through minting.

### ERC20 Token Functions

- **`transfer(address recipient, uint amount)`**: Transfers tokens from the caller’s account to the recipient’s account.
  
- **`mint(address receiver, uint amount)`** *(onlyOwner)*: Allows the contract owner to mint new tokens to any address, increasing the total supply.
  
- **`burn(uint amount)`**: Any user can burn tokens from their balance, reducing the total supply.

### To-Do List Functions

- **`addToDo(string memory description)`** *(onlyOwner)*: Adds a new task to the To-Do List with a given description.
  
- **`updateToDoDescription(uint taskId, string memory newDescription)`** *(onlyOwner)*: Updates the description of a task identified by `taskId`.

- **`completeToDoTask(uint taskId)`** *(onlyOwner)*: Marks a task as completed.

- **`redeemToDoTask(uint taskId)`** *(onlyOwner)*: Redeems a completed task by burning 100 tokens, marking the task as redeemed.

- **`getAllToDos()`**: Returns an array of all tasks in the To-Do List.
  
- **`getToDoById(uint taskId)`**: Retrieves the details of a specific task identified by `taskId`.

### Events

The contract emits the following events to provide transparency and allow users to track actions:

- **`Transfer(address indexed from, address indexed to, uint amount)`**: Triggered when tokens are transferred, minted, or burned.
- **`ToDoAdded(uint indexed taskId, string description, uint timestamp)`**: Emitted when a new task is added.
- **`ToDoCompleted(uint indexed taskId)`**: Emitted when a task is marked as completed.
- **`ToDoUpdated(uint indexed taskId, string newDescription)`**: Emitted when a task's description is updated.
- **`ToDoRedeemed(uint indexed taskId, address redeemer, uint redeemedAmount)`**: Emitted when a task is redeemed and tokens are burned.

## Tools Used

- **Solidity**: Smart contract programming language.
- **Node.js**: Development and package management.
- **Hardhat**: Ethereum development environment.
- **Avalanche Network**: Deploying the contract on Avalanche.

## Setup and Deployment

1. **Clone the Repository**:
    ```bash
    git clone https://github.com/ankur3085/ETH_Intermediate_Module4.git
    ```

2. **Install Dependencies**:
    ```bash
    cd ETH_Intermediate_Module4
    npm install
    ```

3. **Configure Environment**:
   - Create a `.env` file and add your private key and API keys. Example:
     ```bash
     PRIVATE_KEY=your_private_key
     ETHERSCAN_API_KEY=your_etherscan_api_key
     AVAX_NETWORK_ID=fuji
     ```

4. **Compile the Contract**:
    ```bash
    npx hardhat compile
    ```

5. **Deploy the Contract**:
    ```bash
    npx hardhat run scripts/deploy.js --network avaxTestnet
    ```

6. **Verify the Contract**:
   - After deployment, you can verify the contract on Avalanche's Snowtrace explorer.

## Usage

1. **Mint Tokens**: The contract owner can mint tokens to any address using `mint(receiver, amount)`.
2. **Transfer Tokens**: Users can transfer tokens using `transfer(recipient, amount)`.
3. **Burn Tokens**: Any user can burn their tokens using `burn(amount)`.
4. **Manage Tasks**: The owner can add, update, and complete tasks in the To-Do List.

## Help and Resources

If you encounter issues or need further assistance, check the following resources:

- **[Hardhat Documentation](https://hardhat.org/getting-started/)**: For Hardhat setup and usage.
- **[Avalanche Documentation](https://docs.avax.network/)**: For deploying on the Avalanche network.
- **[Solidity Documentation](https://docs.soliditylang.org/)**: For Solidity language specifics.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
