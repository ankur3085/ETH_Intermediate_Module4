// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface IERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
    
    event Transfer(address indexed from, address indexed to, uint amount);
}

contract ERC20 is IERC20 {
    address public immutable owner;
    uint public totalSupply;
    mapping (address => uint) public balanceOf;

    struct ToDo {
        uint taskId;
        string description;
        bool isCompleted;
        uint timestamp;
    }
    
    mapping(uint => ToDo) public toDoList;
    uint public taskCount;

    // Event to log ToDo actions
    event ToDoAdded(uint indexed taskId, string description, uint timestamp);
    event ToDoCompleted(uint indexed taskId);
    event ToDoUpdated(uint indexed taskId, string newDescription);

    constructor() {
        owner = msg.sender;
        totalSupply = 0;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the contract owner can execute this function");
        _;
    }

    string public constant name = "Degen";
    string public constant symbol = "DGN";
    uint8 public constant decimals = 0;

    function transfer(address recipient, uint amount) external returns (bool) {
        require(balanceOf[msg.sender] >= amount, "The balance is insufficient");

        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;

        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function mint(address receiver,uint amount) external onlyOwner {
        balanceOf[receiver] += amount;
        totalSupply += amount;
        emit Transfer(address(0), receiver, amount);
    }

    function burn(uint amount) external {
        require(amount > 0, "Amount should not be zero");
        require(balanceOf[msg.sender] >= amount, "The balance is insufficient");
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;

        emit Transfer(msg.sender, address(0), amount);
    }
    
    // Function to add a new to-do task
    function addToDo(string memory description) external onlyOwner {
        taskCount++;
        toDoList[taskCount] = ToDo({
            taskId: taskCount,
            description: description,
            isCompleted: false,
            timestamp: block.timestamp
        });
        emit ToDoAdded(taskCount, description, block.timestamp);
    }

    // Function to update a to-do task's description
    function updateToDoDescription(uint taskId, string memory newDescription) external onlyOwner {
        ToDo storage task = toDoList[taskId];
        require(bytes(task.description).length != 0, "Task with the given ID does not exist");
        task.description = newDescription;
        emit ToDoUpdated(taskId, newDescription);
    }

    // Function to mark a to-do task as completed
    function completeToDoTask(uint taskId) external onlyOwner {
        ToDo storage task = toDoList[taskId];
        require(bytes(task.description).length != 0, "Task with the given ID does not exist");
        require(!task.isCompleted, "Task is already completed");
        task.isCompleted = true;
        emit ToDoCompleted(taskId);
    }

    // Function to get all tasks in the to-do list
    function getAllToDos() external view returns (ToDo[] memory) {
        ToDo[] memory allTasks = new ToDo[](taskCount);
        for (uint i = 1; i <= taskCount; i++) {
            allTasks[i - 1] = toDoList[i];
        }
        return allTasks;
    }

    // Function to get a single to-do task by ID
    function getToDoById(uint taskId) external view returns (ToDo memory) {
        return toDoList[taskId];
    }
}

