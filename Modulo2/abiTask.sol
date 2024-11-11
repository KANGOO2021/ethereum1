// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TodoList {
    struct Task {
        string description;
        bool isCompleted;
    }

    Task[] public tasks;

    function addTask(string memory _description) public {
        tasks.push(Task(_description, false));
    }

    function markTaskCompleted(uint _taskId) public {
        tasks[_taskId].isCompleted = true;
    }

    function getTask(uint _taskId) public view returns (string memory, bool) {
        Task storage task = tasks[_taskId];
        return (task.description, task.isCompleted);
    }
}

//Para este contrato, un ABI de ejemplo que describa las funciones disponibles podría verse así:

/*[
    {
        "inputs": [
            {
                "internalType": "string",
                "name": "_description",
                "type": "string"
            }
        ],
        "name": "addTask",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "uint256",
                "name": "_taskId",
                "type": "uint256"
            }
        ],
        "name": "markTaskCompleted",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "uint256",
                "name": "_taskId",
                "type": "uint256"
            }
        ],
        "name": "getTask",
        "outputs": [
            {
                "internalType": "string",
                "name": "",
                "type": "string"
            },
            {
                "internalType": "bool",
                "name": "",
                "type": "bool"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    }
]*/

/*Ejemplo de Uso del ABI

Imagina que tienes un contrato inteligente en Solidity que incluye una función para obtener 
el nombre de un usuario. Para llamar a esta función desde una aplicación web, necesitarías el
ABI del contrato. Con el ABI, puedes utilizar una librería de Ethereum como web3.js o ethers.js
para crear una instancia del contrato en tu aplicación y hacer llamadas a sus funciones como
si fueran funciones JavaScript.*/

/* 

const contractABI = // ABI del contrato inteligente aquí ;
const contractAddress = '0x...'; // La dirección del contrato desplegado
const web3 = new Web3('<http://localhost:8545>');
const myContract = new web3.eth.Contract(contractABI, contractAddress);

// Llamando a una función del contrato
myContract.methods.nombreDeLaFuncion().call()
    .then(result => {
        console.log(result);
    }); */