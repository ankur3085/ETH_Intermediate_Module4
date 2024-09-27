# DegenToken with To-Do List Smart Contract

Welcome to the **DegenToken** project! This repository contains the implementation of an ERC20-compatible smart contract, along with a built-in task management (To-Do List) system. This contract can be used for managing tokens and tracking tasks, making it a great starting point for blockchain-based applications with resource and task management features.

## Project Overview

The **DegenToken** is a custom ERC20 token with the symbol `DGN` and no decimal places (tokens are represented as whole numbers). In addition to standard ERC20 functionality like transferring and minting tokens, the contract owner can create, update, and complete tasks in a To-Do List. This project can be used in various gaming or management ecosystems where task tracking and token-based transactions are essential.

## Features

### ERC20 Token

- **Name**: Degen (`DGN`)
- **Decimals**: 0 (whole units, no fractional tokens)
- **Token Minting**: The owner can mint new tokens.
- **Token Burning**: Any user can burn their own tokens.
- **Transfers**: Users can transfer tokens to others.

### To-Do List

- **Add Tasks**: The owner can add tasks to the To-Do List.
- **Update Tasks**: The owner can modify the description of any task.
- **Mark Tasks as Completed**: The owner can mark tasks as completed.
- **View Tasks**: Users can view all tasks or retrieve specific tasks by ID.

## Contract Details

### Constructor

The contract is initialized with the following:

```solidity
constructor() {
    owner = msg.sender;
    totalSupply = 0;
}
```

- **Owner**: The deployer of the contract is assigned as the owner and has exclusive privileges to mint tokens and manage tasks.
- **Total Supply**: Initially set to zero, but can be increased by minting.

### ERC20 Token Functions

- **`transfer(address recipient, uint amount)`**: Transfers tokens from the caller’s account to the recipient’s account.
  
- **`mint(address receiver, uint amount)`** *(onlyOwner)*: The contract owner can mint new tokens to any address, increasing the total supply.
  
- **`burn(uint amount)`**: Any user can burn tokens from their balance, reducing the total supply.

### To-Do List Functions

- **`addToDo(string memory description)`** *(onlyOwner)*: Adds a new task to the To-Do list.
  
- **`updateToDoDescription(uint taskId, string memory newDescription)`** *(onlyOwner)*: Updates the description of a specific task identified by `taskId`.

- **`completeToDoTask(uint taskId)`** *(onlyOwner)*: Marks a task as completed.

- **`getAllToDos()`**: Returns all tasks in the To-Do list.
  
- **`getToDoById(uint taskId)`**: Retrieves details of a specific task identified by `taskId`.

### Events

The contract emits the following events for transparency and interaction tracking:

- **`Transfer(address indexed from, address indexed to, uint amount)`**: Triggered when tokens are transferred, minted, or burned.
- **`ToDoAdded(uint indexed taskId, string description, uint timestamp)`**: Emitted when a new task is added.
- **`ToDoCompleted(uint indexed taskId)`**: Emitted when a task is marked as completed.
- **`ToDoUpdated(uint indexed taskId, string newDescription)`**: Emitted when a task's description is updated.

## Tools Used

- **Solidity**: Smart contract language.
- **NodeJS**: For development and package management.
- **Hardhat**: Ethereum development environment.
- **Avalanche Network**: Deploying the contract on Avalanche.

## Setup and Deployment

1. **Clone the Repository:**
    ```bash
    git clone https://github.com/YourUsername/Degen-Token-ToDo.git
    ```

2. **Install Dependencies:**
    ```bash
    cd Degen-Token-ToDo
    npm install
    ```

3. **Configure Environment:**
   - Create a `.env` file and add your private key and API keys. Example:
     ```bash
     PRIVATE_KEY=your_private_key
     ETHERSCAN_API_KEY=your_etherscan_api_key
     AVAX_NETWORK_ID=fuji
     ```

4. **Compile the Contract:**
    ```bash
    npx hardhat compile
    ```

5. **Deploy the Contract:**
    ```bash
    npx hardhat run scripts/deploy.js --network avaxTestnet
    ```

6. **Verify the Contract**:
   - After deploying, you can verify the contract on Avalanche's Snowtrace explorer.

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
