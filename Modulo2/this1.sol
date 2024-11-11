// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyContract {
    function sendEther(address payable recipient) public payable {
        // Enviar todo el Ether enviado a esta función al destinatario
        recipient.transfer(msg.value);
    }

    function contractBalance() public view returns (uint) {
        // Acceder al balance de Ether del contrato usando `this`
        return address(this).balance;
    }
}