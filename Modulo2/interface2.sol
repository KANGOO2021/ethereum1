// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interface.sol";

contract Greeter is IGreeter {
    function greet(string calldata _name) external pure override returns (string memory) {
        return string(abi.encodePacked("Hello, ", _name));
    }
}