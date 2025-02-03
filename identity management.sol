// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TelecomIdentityManagement {
    struct User {
        string publicKey;
        bool isRegistered;
        string[] services;
    }

    mapping(address => User) public users;
    address public telecomProvider;

    // Constructor to set the telecom provider (the contract deployer)
    constructor() {
        telecomProvider = msg.sender;
    }

    // Function to register a new user
    function registerUser(address _userAddress, string memory _publicKey) public {
        require(!users[_userAddress].isRegistered, "User is already registered.");
        users[_userAddress].publicKey = _publicKey;
        users[_userAddress].isRegistered = true;
    }

    // Function to authenticate a user
    function authenticateUser(address _userAddress, string memory _publicKey) public view returns (bool) {
        require(users[_userAddress].isRegistered, "User is not registered.");
        return keccak256(abi.encodePacked(users[_userAddress].publicKey)) == keccak256(abi.encodePacked(_publicKey));
    }

    // Function to assign a service to a user (only telecom provider can assign)
    function assignService(address _userAddress, string memory _serviceName) public {
        require(msg.sender == telecomProvider, "Only telecom provider can assign services.");
        require(users[_userAddress].isRegistered, "User is not registered.");
        users[_userAddress].services.push(_serviceName);
    }

    // Function to get all services assigned to a user
    function getServices(address _userAddress) public view returns (string[] memory) {
        require(users[_userAddress].isRegistered, "User is not registered.");
        return users[_userAddress].services;
    }
}
