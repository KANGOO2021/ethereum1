// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
 contract OperatorDemo {
		// Inicializa variable de estado 
		uint  public first = 10; 
		//Asignación simple
		 function simpleAssignment() public {
		 first = 20; 
			} 
		//Asignación suma
		 function addAssignment() public {
			first += 10; 
			} 
		//Asignación resta
		function substractAssignment() public {
		 first -= 10; 
			}
		 //Asignación multiplicación
		 function multiplyAssignment() public {
		 first *= 5; 
			} 
		 //Asignación división
		function divideAssignment() public {
		 first /= 3;
			} 
		//Asignación módulo
		function modulusAssignment() public {
		 first %= 3; 
			} 
}