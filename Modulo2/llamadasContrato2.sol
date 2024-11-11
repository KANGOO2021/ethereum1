// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


//llamadas de bajo nivel
contract MiContrato {
    function llamarFuncionExternaBajoNivel(address direccionExterna, string memory mensaje) public returns (bool, bytes memory) {
        (bool exito, bytes memory respuesta) = direccionExterna.call(
            abi.encodeWithSignature("funcionExterna(string)", mensaje)
        );
        return (exito, respuesta);
    }
}