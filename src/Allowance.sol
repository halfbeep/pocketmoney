// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Allowance {
    address[] public children;
    uint256 public frequency;
    uint256 public amount;
    uint256 internal lastPaymentTime;
    address private owner;

    // Constructor to initialize the contract with the recipients and weekly amount
    constructor(
        address[] memory _children,
        uint256 _amount,
        uint256 _frequency
    ) {
        owner = msg.sender;
        children = _children;
        amount = _amount;
        frequency = _frequency;
        lastPaymentTime = block.timestamp; // Set the last payment time to the current block timestamp
    }

    function setAmount(uint256 newNumber) public {
        require(msg.sender == owner, "Not owner");
        amount = newNumber;
    }

    function setFrequency(uint256 secsFrequency) public {
        // frequency stores in seconds
        require(msg.sender == owner, "Not owner");
        frequency = secsFrequency;
    }

    // Modifier to check if a week has passed
    modifier timePassed() {
        require(
            block.timestamp >= lastPaymentTime + frequency,
            "Allowance not yet available"
        );
        _;
    }

    // Function to release Ether to the children if a week has passed
    function releaseAllowance() external timePassed {
        uint256 totalAmount = amount * children.length;
        require(
            address(this).balance >= totalAmount,
            "Insufficient contract balance"
        );

        for (uint256 i = 0; i < children.length; i++) {
            payable(children[i]).transfer(amount);
        }

        lastPaymentTime = block.timestamp; // Update last payment time
    }

    // Function to check the balance of the contract
    function contractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // (fallback) function to allow children to withdraw Ether
    receive() external payable {}

    // Function to allow contract to receive funds
    function fundContract() external payable {}
}
