// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {
    // Token price in wei (1 token = 0.000000025 ETH)
    uint256 public constant TOKEN_PRICE = 0.000000000025 ether;

    //Placeholders
    uint256 public totalFruits;
    uint256 public totalGrass;
    uint256 public totalEggs;
    uint256 public totalMilk;
    uint256 public totalAnimals;
    uint256 public totalSeeds;
    uint256 public totalTokens;

    // Events
    event Seeds(address indexed farmer, uint256 value);
    event Grass(address indexed farmer, uint256 value);
    event Eggs(address indexed farmer, uint256 value);
    event Milk(address indexed farmer, uint256 value);
    event Fruits(address indexed farmer, uint256 value);
    event Animals(address indexed farmer, uint256 value);
    event Tokens(address indexed buyer, uint256 value, uint256 cost);

    constructor() ERC20("Degen", "DGN") {
        // Mint initial supply to the owner
        uint256 amount = 10**2;
        _mint(msg.sender, amount);
        totalTokens +=amount;

        // Initialize total resources
        totalFruits = 0;
        totalGrass = 10;
        totalEggs = 0;
        totalMilk = 0;
        totalAnimals = 2;
        totalSeeds = 10;
    }

    // Function to mint tokens (onlyOwner)
    function mint(address to, uint256 value) public onlyOwner {
        _mint(to, value);
    }

    // Function to burn tokens (anyone can burn tokens they own)
    function burn(uint256 value) public {
        require(value > 0, "Amount must be greater than zero");
        require(balanceOf(msg.sender) >= value, "Insufficient balance");

        _burn(msg.sender, value);
    }

     // Function to transfer tokens to other players
    function transferTokens(address _receiver, uint256 value) external {
        require(balanceOf(msg.sender) >= value, "You do not have enough Tokens");
        approve(msg.sender, value);
        transferFrom(msg.sender, _receiver, value);
    }

    // Function to purchase tokens with ETH
    function purchaseTokens(uint256 buyTokens) public payable {
    require(buyTokens > 0, "Specify the amount of tokens to buy");
    
    // Calculate the required amount of AVAX based on TOKEN_PRICE
    uint256 requiredETH = buyTokens * TOKEN_PRICE / (10 ** 2);

    // Ensure the user has sent enough AVAX
    require(msg.value >= requiredETH, "Not enough AVAX sent");

    // Check if the contract has enough tokens
    uint256 contractBalance = balanceOf(address(this));
    require(contractBalance >= buyTokens * 10 ** 2, "Not enough tokens in the reserve");

    // Transfer the tokens to the buyer
    _transfer(address(this), msg.sender, buyTokens * 10 ** 2);

    // Emit event for token purchase
    emit Tokens(msg.sender, buyTokens, msg.value);

    // Refund any excess ETH (AVAX) sent
    if (msg.value > requiredETH) {
        payable(msg.sender).transfer(msg.value - requiredETH);
    }
    }

    // Function to withdraw ETH from the contract
    function withdrawETH() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    // Function to purchase seeds with tokens (redeeming tokens)
    function purchase_seeds(uint256 value) public {
        require(value > 0, "Amount must be greater than zero");
        require(balanceOf(msg.sender) >= value, "Insufficient balance");

        // Deduct tokens from sender
        burn(value);

        //Update Values
        totalSeeds += value;

        // Emit event for seeds purchase
        emit Seeds(msg.sender, value);
    }

    // Function to feed grass to animals and get rewards (eggs and milk)
    function feed_grass_to_animals(uint256 value) public {
        require(value > 0, "Amount must be greater than zero");
        require(totalGrass >= value, "Not enough grass available");

        // Emit event for feeding grass
        emit Grass(msg.sender, value);

        uint256 eggs_clt = value * 4; // Get 4 eggs for each unit of grass fed
        uint256 milk_clt = value * 2; // Get 2 liter of milk for each unit of grass fed

        //Update Values
        totalGrass -= value;
        totalEggs += eggs_clt;
        totalMilk += milk_clt;

        // Emit events for eggs and milk collected
        emit Eggs(msg.sender, eggs_clt);
        emit Milk(msg.sender, milk_clt);
    }

    // Function to purchase animals
    function purchase_animals(uint256 value) public {
        require(value > 0, "Amount must be greater than zero");
        require(balanceOf(msg.sender) >= value, "Not enough balance available");

        totalAnimals += value;
        uint256 t_ani = value*50;

        burn(t_ani);

        // Emit event for fruits harvested
        emit Animals(msg.sender, value);
    }

    // Function to harvest fruits
    function harvest_fruits(uint256 value) public {
        require(value > 0, "Amount must be greater than zero");
        require(totalSeeds >= value, "Not enough seeds available");

        totalSeeds -= value;
        totalFruits += value;

        // Emit event for fruits harvested
        emit Fruits(msg.sender, value);
        emit Seeds(msg.sender, value);
    }

    // Function to harvest grass
    function harvest_grass(uint256 value) public {
        require(value > 0, "Amount must be greater than zero");
        require(balanceOf(msg.sender) >= value, "Not enough balance available");

        totalGrass += value;

        burn(value);

        // Emit event for grass harvested
        emit Grass(msg.sender, value);
    }

    //Function to sell fruits and earn rewards
    function sell_fruits(uint256 value) public {
        require(value > 0, "Amount must be greater than zero");
        require(totalFruits >= value, "Not enough fruits available");

        totalFruits -= value;
        uint256 reward = value*2;
        mint(msg.sender,reward);

        // Emit event for selling fruits
        emit Fruits(msg.sender, value);
    }

    //Function to sell Eggs and earn rewards
    function sell_Eggs(uint256 value) public {
        require(value > 0, "Amount must be greater than zero");
        require(totalEggs >= value, "Not enough eggs available");

        totalEggs -= value;
        uint256 reward = value*2;
        mint(msg.sender,reward);

        // Emit event for selling eggs
        emit Fruits(msg.sender, value);
    }

    //Function to sell milk and earn rewards
    function sell_milk(uint256 value) public {
        require(value > 0, "Amount must be greater than zero");
        require(totalMilk >= value, "Not enough milk available");

        totalMilk -= value;
        uint256 reward = value*4;
        mint(msg.sender,reward);

        // Emit event for selling milk
        emit Milk(msg.sender, value);
    }

    //Function to sell animals and earn rewards
    function sell_animals(uint256 value) public {
        require(value > 0, "Amount must be greater than zero");
        require(totalAnimals >= value, "Not enough animals available");

        totalAnimals -= value;
        uint256 reward = value*50;
        mint(msg.sender,reward);

        // Emit event for fruits harvested
        emit Animals(msg.sender, value);
    }
}
