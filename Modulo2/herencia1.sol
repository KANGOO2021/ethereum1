// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Contrato padre
contract Base {
    uint public data;

    constructor(uint _data) {
        data = _data;
    }

    function setData(uint _data) virtual public {
        data = _data;
    }
}

// Contrato hijo que hereda de Base
contract Derived is Base {
    constructor(uint _initialData) Base(_initialData) {
        // Inicializa el contrato padre con _initialData
    }

    // Sobrescritura de la función setData
    function setData(uint _data) public override {
        data = _data + 10; // Cambia la implementación para sumar 10 antes de almacenar
    }
}