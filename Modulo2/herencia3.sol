// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Contrato padre común
contract Vehicle {
    string public brand;
    string public model;

    constructor(string memory _brand, string memory _model) {
        brand = _brand;
        model = _model;
    }

    function getVehicleInfo() public view returns (string memory, string memory) {
        return (brand, model);
    }
}

// Primer contrato hijo que hereda de Vehicle
contract Car is Vehicle {
    uint public carMaxSpeed;

    constructor(string memory _brand, string memory _model, uint _maxSpeed)
        Vehicle(_brand, _model) {
        carMaxSpeed = _maxSpeed;
    }

    function getMaxSpeed() public view returns (uint) {
        return carMaxSpeed;
    }
}

// Segundo contrato hijo que hereda de Vehicle
contract Truck is Vehicle {
    uint public truckLoadCapacity;

    constructor(string memory _brand, string memory _model, uint _loadCapacity)
        Vehicle(_brand, _model) {
        truckLoadCapacity = _loadCapacity;
    }

    function getLoadCapacity() public view returns (uint) {
        return truckLoadCapacity;
    }
}