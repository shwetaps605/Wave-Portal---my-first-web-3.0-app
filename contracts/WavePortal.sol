//SPDX license identifiers
pragma solidity ^0.8.4; //version of the solidity compiler we want to use

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;
    event NewWave(address indexed, uint256, string);
    uint256 private seed;

    struct Wave {
        address waver; //the address of the person who waved
        string message; // the message sent by the person
        uint256 timestamp; // the timestamp when the user waved
    }

    Wave[] waves;

    mapping(address => uint256) public lastWavedAt;

    constructor() payable {
        console.log("Yo yo,I am smart - said the Constructor");
        //Initialize seed value
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public {

        require( lastWavedAt[msg.sender] + 30 seconds < block.timestamp, "Dude. maybe you could wait for 15 minutes that'd be really awesome!");

        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        console.log("%s has waved", msg.sender);
        waves.push(Wave(msg.sender, _message, block.timestamp));
        //Generate a new seed value for every user who waves
        seed = (block.timestamp + block.difficulty + seed) % 100;
        console.log("Seed value generated is",seed);
        if (seed <= 50) {
            console.log("%s won",msg.sender);
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );

            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contact");
        }

        emit NewWave(msg.sender, block.timestamp, _message);
    }

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves", totalWaves);
        return totalWaves;
    }
}
