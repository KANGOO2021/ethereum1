// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title Concepts: Type address, msg.sender, owner, if
/// @author Solange Gueiros
contract Owner {
    string private storedInfo;
    address public owner;
		// El constructor define como dueño a quien despliega el contrato.
    constructor() {
        owner = msg.sender;
    }

    /**
    * La función setInfo verifica si quien envía la transacción
    * es el dueño del contrato.
    * Si es así, modifica el valor de la variable. Sino no hace nada.
    */


    /* function setInfo(string memory myInfo) external {
        if (msg.sender == owner) {
            storedInfo = myInfo;
        }
    } */


   /* ¿Cómo modificaría la función setInfo en el contrato anterior para utilizar
    la estructura de control requireen lugar de if? */
    function setInfo(string memory myInfo) external {
        require(msg.sender == owner, "Only owner");
        storedInfo = myInfo;
    }

    function getInfo() external view returns (string memory) {
        return storedInfo;
    }
}