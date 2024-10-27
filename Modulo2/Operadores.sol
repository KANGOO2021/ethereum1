// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.13; 
contract OperatorDemo {
	 // Inicializar variables
	 uint16 public first = 10;
	 uint16 public second = 30;
	 // Inicializar una variable con el operador de suma
	 uint public addition  = first + second;
	 // Inicializar una variable con el operador de resta
	 uint public subtraction  = second - first; 
		// Inicializar una variable con una multiplicación
	 uint public multiplication  = first * second;
	 // Inicializar una variable con el cociente de una división
	 uint public division = first / second; 
		// Inicializando una variable con módulo
		uint public modulus = first % second; 
		// Inicializar una variable con un valor reducido en uno
		uint public decrement = --second;
		// Inicializar una variable con un valor incrementado en uno
		uint public increment = ++first; 
}