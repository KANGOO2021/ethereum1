// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.13; 
contract OperatorDemo { 
		// Inicializar variables
		 bool public first = true; 
		 bool public second = false; 
		// Inicializar una variable con el resultado de un AND
		 bool public and = first&&second; 
		// Inicializar una variable con el resultado de un OR
		 bool public or = first||second;
		// Inicializar una variable con el resultado de un NOT
		 bool public not = !second; 
}