// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract HelloWorld {
    string public greet = "Hello World!";
    enum Estado{
        Pendiente, Aprobado, Rechazado
    }
    Estado public miEstado; // uint8
    uint8 _a=4;

    function setMiEstadoAprobado() external payable {
        miEstado = Estado.Aprobado;
        setMiEstadoRechazado();
    }

    function setMiEstadoRechazado() internal {
        miEstado = Estado.Rechazado;
    }

    function suma( uint8 b) external view returns(uint8 c) {
        return _a + b;
    }

    function getMaxVal() public pure returns(int8) {
        int8 maxVal = type(int8).max;
        return maxVal;
    }
}