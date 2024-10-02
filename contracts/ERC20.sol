// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, Ownable {
    struct ToDo {
        uint taskId;
        string description;
        bool isCompleted;
        bool isRedeemed;
        uint timestamp;
        address assignedUser;
    }

    mapping(uint => ToDo) public toDoList;
    uint public taskCount;
    uint public constant REDEEM_AMOUNT = 100;

    // Events
    event ToDoAdded(uint indexed taskId, string description, uint timestamp, address assignedUser);
    event ToDoCompleted(uint indexed taskId);
    event ToDoUpdated(uint indexed taskId, string newDescription);
    event ToDoRedeemed(uint indexed taskId, address redeemer, uint redeemedAmount);
    event TokensTransferred(address from, address to, uint amount);

    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {
        // Mint initial supply to the owner
        uint256 initialSupply = 10 ** 2;
        _mint(msg.sender, initialSupply);
    }

    // Function to mint tokens when a new task is added
    function addToDo(string memory description, address assignedUser) external onlyOwner {
        taskCount++;
        toDoList[taskCount] = ToDo({
            taskId: taskCount,
            description: description,
            isCompleted: false,
            isRedeemed: false,
            timestamp: block.timestamp,
            assignedUser: assignedUser
        });
        // Mint 10 tokens as reward for adding a new task
        _mint(assignedUser, 10 * (10 ** decimals()));
        emit ToDoAdded(taskCount, description, block.timestamp, assignedUser);
    }

    // Function to mark a to-do task as completed
    function completeToDoTask(uint taskId) external onlyOwner {
        ToDo storage task = toDoList[taskId];
        require(bytes(task.description).length != 0, "Task with the given ID does not exist");
        require(!task.isCompleted, "Task is already completed");
        task.isCompleted = true;
        emit ToDoCompleted(taskId);
    }

    // Function to redeem a completed to-do task by burning tokens
    function redeemToDoTask(uint taskId) external onlyOwner {
        ToDo storage task = toDoList[taskId];
        require(task.isCompleted, "Task must be completed before redeeming");
        require(!task.isRedeemed, "Task has already been redeemed");

        task.isRedeemed = true;
        // Burn 100 tokens from the owner as a redemption reward
        burn(REDEEM_AMOUNT);
        emit ToDoRedeemed(taskId, msg.sender, REDEEM_AMOUNT);
    }

    // Transfer task ownership and reward tokens to the assigned user
    function transferTask(uint taskId, address newAssignedUser) external onlyOwner {
        ToDo storage task = toDoList[taskId];
        require(task.assignedUser != newAssignedUser, "Task is already assigned to this user");
        require(newAssignedUser != address(0), "Cannot transfer to the zero address");

        // Transfer ownership
        task.assignedUser = newAssignedUser;

        // Transfer 10 tokens to the new assigned user as a reward
        _transfer(msg.sender, newAssignedUser, 10 * (10 ** decimals()));
        emit TokensTransferred(msg.sender, newAssignedUser, 10 * (10 ** decimals()));
    }

    // Transfer tokens linked to ToDo task assignment
    function transferTokens(address receiver, uint256 amount) external onlyOwner {
        require(receiver != address(0), "Invalid receiver address");
        _transfer(msg.sender, receiver, amount);
        emit TokensTransferred(msg.sender, receiver, amount);
    }

    // Redeem a completed task by burning tokens
    function burn(uint256 amount) public {
        _burn(_msgSender(), amount);
    }

    function mint(address receiver, uint256 amount) external onlyOwner {
        _mint(receiver, amount);
    }

    // Get all tasks in the to-do list
    function getAllToDos() external view returns (ToDo[] memory) {
        ToDo[] memory allTasks = new ToDo[](taskCount);
        for (uint i = 1; i <= taskCount; i++) {
            allTasks[i - 1] = toDoList[i];
        }
        return allTasks;
    }

    // Get a single to-do task by ID
    function getToDoById(uint taskId) external view returns (ToDo memory) {
        return toDoList[taskId];
    }
}
