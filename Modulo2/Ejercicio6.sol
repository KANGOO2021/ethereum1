// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title Concepts: array = list of infos stored
/// @author Solange Gueiros
contract FirsArray {
    string[] private storedInfos;

    /**
    * Graba nuevos valores en el array usando push()
    * index devuelve la posición en la que se grabó el valor 
    */
    function addInfo(string memory myInfo) external returns (uint index) {
        storedInfos.push(myInfo);
        index = storedInfos.length -1;
    }

    /**
    * Modifica el valor de la posición index del array con un nuevo valor
    * Verifica que la posición sea válida, sino devuelve un error
    */
    function updateInfo(uint index, string memory newInfo) external {
        require (index < storedInfos.length, "invalid index");
        storedInfos[index] = newInfo;
    }

    /**
    * Devuelve el valor almacenado en la posición index del array
    * Verifica que la posición sea válida, sino devuelve un error
    */
    function getOneInfo(uint index) external view returns (string memory) {
        require (index < storedInfos.length, "invalid index");
        return storedInfos[index];
    }

    // Devuelve todos los valores contenidos en el array
    function listAllInfo() external view returns (string[] memory) {
        return storedInfos;
    } 
}