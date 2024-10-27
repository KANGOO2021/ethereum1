// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.13; 
contract OperatorDemo {
		// Inicializar variables
		 uint16 public first = 10;
		 uint16 public second = 30;
	  // Inicializar una variable (bool) con el resultado de una comparación igual  
			bool public equal = first == second; 
		// Inicializar una variable (bool) con el resultado de una comparación diferente 
		 bool public not_equal = first != second;
		// Inicializar una variable (bool) con el resultado de una comparación mayor
		bool public greater = second > first; 
		// Inicializar una variable (bool) con el resultado de una comparación menor
		bool public less = first < second; 
		// Inicializar una variable (bool) con el resultado de una comparación mayor o igual que
		bool public greaterThanEqualTo = second >= first; 
		/// Inicializar una variable (bool) con el resultado de una comparación menor o igual que
		bool public lessThanEqualTo = first <= second; 
}