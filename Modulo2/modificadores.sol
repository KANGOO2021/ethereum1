// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.13;

contract MyContract {
    address public owner;

    constructor() {
        owner = msg.sender; // Establece el dueño del contrato al ser desplegado
    }

    // Definición del modificador
    modifier onlyOwner() {
        require(msg.sender == owner, "Solo el propietario puede ejecutar esta funcion.");
        _; // Continúa con la ejecución de la función modificada
    }

    // Uso del modificador en una función
    function myRestrictedFunction() public onlyOwner {
        // Lógica de la función aquí
    }
}