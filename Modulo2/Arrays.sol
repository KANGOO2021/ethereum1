// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13; 

contract ArraysDS { 
		// Se declara un array dinámico de tipo entero 
		int[] numbers; 
		// función para añadir valores a un array  
		function store() public returns (int[] memory){ 
			numbers.push(5);
			numbers.push(10);
			numbers.push(20);
			return  numbers; 
		}  

		//función para retirar el ultimo valor del array
		function deleteLastElement() public returns(int[] memory){
		  numbers.pop(); 
			return numbers;  
		} 
} 