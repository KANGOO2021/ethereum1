// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HashingExample {
    // Función para calcular el hash de una cadena de caracteres
    function calculateHash(string memory _input) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_input));
    }
}