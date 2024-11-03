// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract MyContract {
    // Definición del evento
    event MyEvent(address indexed sender, uint256 value);

    function triggerEvent() public {
        // Lógica de la función aquí...

        // Emitir el evento con los valores específicos
        emit MyEvent(msg.sender, 100);
    }
}