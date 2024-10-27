// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Conditional {

    function ternary(uint _x) public pure returns (uint) {
        // Si _x es menor que 10, que la función devuelva 1, sino que devuelva 2
        return _x < 10 ? 1 : 2;
    }
}