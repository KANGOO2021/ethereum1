// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title Concepts: event
/// @author Solange Gueiros
contract EventEmitter {
    string private storedInfo;
		// Define un evento para informar un cambio en storedInfo
    event InfoChange(string oldInfo, string newInfo);

    // Emite el evento cuando el valor de storedInfo va a ser cambiado
    
    function setInfo(string memory myInfo) external {
        emit InfoChange (storedInfo, myInfo);
        storedInfo = myInfo;
    } 

    function getInfo() external view returns (string memory) {
        return storedInfo;
    }   
}