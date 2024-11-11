// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


//contrato externo
interface ContratoExterno {
    function funcionExterna(string calldata mensaje) external returns (bool);
}


//mi contrato local
contract MiContrato {
    function llamarFuncionExterna(address direccionExterna, string memory mensaje) public returns (bool) {
        ContratoExterno contrato = ContratoExterno(direccionExterna);
        return contrato.funcionExterna(mensaje);
    }
}