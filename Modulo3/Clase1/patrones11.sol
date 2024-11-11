// Patrón de Comparación de Strings

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StringComparison {
    // Función para comparar dos strings
    function compareStrings(string memory string1, string memory string2) public pure returns (bool) {
        return keccak256(abi.encodePacked(string1)) == keccak256(abi.encodePacked(string2));
    }
}