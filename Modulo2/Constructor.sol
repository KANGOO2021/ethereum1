// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MyContract {

    uint256 public myNumber;
    address public owner;

    constructor(uint256 _myNumber) {
        myNumber = _myNumber;
        owner = msg.sender;
    }
}