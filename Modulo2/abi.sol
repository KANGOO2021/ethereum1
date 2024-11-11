// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Receiver {
    event Received(uint256 indexed value, address sender);

    // Una función simple que emite un evento con el valor y el remitente
    function receiveValue(uint256 value) public {
        emit Received(value, msg.sender);
    }
}

contract Caller {
    // Función que llama a `receiveValue` en el contrato Receiver usando abi.encodeWithSelector
    function callReceiveValue(address _receiver, uint256 _value) public {
        // Primero, calculamos el selector de la función.
        // La firma de la función es "receiveValue(uint256)"
        bytes4 selector = bytes4(keccak256("receiveValue(uint256)"));

        // Luego, codificamos el selector junto con los argumentos de la función.
        bytes memory data = abi.encodeWithSelector(selector, _value);

        // Realizamos la llamada de bajo nivel.
        (bool success, ) = _receiver.call(data);
        require(success, "La llamada fallo.");
    }
}