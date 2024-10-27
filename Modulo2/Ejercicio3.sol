// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title Concepts: Constructor
/// @author Solange Gueiros
contract FirstConstructor {
    string private storedInfo;
    uint public countChanges = 0;

    /**
    * Usamos el constructor para inicializar la variable stored Info
    */
    constructor() {
        storedInfo = "Hello world";
        // Considera el contador esta inicialización?
        // A revisar en clase
    }
    

    function setInfo(string memory myInfo) external {
        storedInfo = myInfo;
        countChanges++;
    }
    
    function getInfo() external view returns (string memory) {
        return storedInfo;
    }  
}