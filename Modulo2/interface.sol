// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGreeter {
    function greet(string calldata _name) external returns (string memory);
}