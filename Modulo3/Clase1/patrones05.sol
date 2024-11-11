// Patrón de Fábrica de Contratos (Factory Pattern)

/* Contrato Hijo
Primero, definimos el contrato que queremos producir. Este contrato puede ser cualquier cosa,
 pero para fines de este ejemplo, será un simple contrato que almacena un número */

 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Contrato hijo que nuestra fábrica producirá
contract ChildContract {
    uint public number;

    // Constructor que inicializa el contrato con un número específico
    constructor(uint _number) {
        number = _number;
    }
}

/* Contrato Fábrica

El contrato fábrica se encargará de crear nuevas instancias del contrato hijo. Mantendrá un
 registro de todas las instancias creadas para poder interactuar con ellas más tarde si es necesario. */




// Referencia al contrato hijo
//import "./ChildContract.sol"; // se comenta porque debe estar en archivo aparte

contract FactoryContract {
    // Array para almacenar las direcciones de los contratos hijos creados
    ChildContract[] public children;

    event ChildCreated(uint number, address childAddress);

    // Función para crear un nuevo contrato hijo
    function createChild(uint _number) public {
        ChildContract child = new ChildContract(_number);
        children.push(child);
        emit ChildCreated(_number, address(child));
    }

    // Función para obtener la dirección de un contrato hijo en el array
    function getChild(uint _index) public view returns (ChildContract) {
        require(_index < children.length, "Indice fuera de limites");
        return children[_index];
    }
}