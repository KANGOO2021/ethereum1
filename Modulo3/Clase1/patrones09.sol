//Patrón de Mapa Iterable

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract IterableMapping {
    // Estructura para almacenar los datos junto con un flag para marcar si el elemento está en el array
    struct MapData {
        uint value;
        bool exists;
    }

    // Mapa para almacenar los datos asociados a una clave
    mapping(address => MapData) public dataMap;

    // Array para mantener el orden de las claves
    address[] public keys;

    // Función para añadir o actualizar un valor
    function set(address key, uint value) public {
       // Si es la primera vez que se añade, también se agrega la clave al array
        if (!dataMap[key].exists) {
            keys.push(key);
            dataMap[key] = MapData(value, true);
        } else {
            // Si ya existía, solo actualizamos el valor
            dataMap[key].value = value;
        }
    }

    // Función para obtener un valor
    function get(address key) public view returns (uint) {
        require(dataMap[key].exists, "La clave no existe");
        return dataMap[key].value;
    }

    // Función para eliminar un elemento
    function remove(address key) public {
        require(dataMap[key].exists, "La clave no existe");

        // Eliminar la clave del mapa
        delete dataMap[key];

        // Encontrar el índice de la clave en el array y eliminarlo
        for (uint i = 0; i < keys.length; i++) {
            if (keys[i] == key) {
                // Mover el último elemento al lugar del elemento eliminado y luego eliminar el último elemento
                keys[i] = keys[keys.length - 1];
                keys.pop();
                break;
            }
        }
    }

    // Función para obtener el tamaño del mapa
    function size() public view returns (uint) {
        return keys.length;
    }

    // Función para comprobar si una clave existe en el mapa
    function exists(address key) public view returns (bool) {
        return dataMap[key].exists;
    }

    // Función para obtener una clave en un índice específico
    function getKeyAtIndex(uint index) public view returns (address) {
        require(index < keys.length, "Indice fuera de rango");
        return keys[index];
    }
}