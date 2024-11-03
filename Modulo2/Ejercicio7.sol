// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title Concepts: mapping and access control: whiteList
/// @author Solange Gueiros
contract Whitelist {
    string private storedInfo;
    address public owner;
    mapping (address => bool) public whiteList;
    // El constructor inicializa al owner y lo incluye en la whitelist
    constructor() {
        owner = msg.sender;
        whiteList[msg.sender] = true;
        storedInfo = "Hello world";
    }
    
    modifier onlyOwner {
        require(msg.sender == owner,"Only owner");
        _;
    }
    // Se requiere que quien envíe la transacción esté en la whitelist
    modifier onlyWhitelist {
        require(whiteList[msg.sender] == true, "Only whitelist");
        _;
    }

    // setinfo solo accesible para quien esté en la whitelist
    function setInfo(string memory myInfo) external onlyWhitelist {
        storedInfo = myInfo;
    }

    // addMember sólo accesible para el dueño del contrato
    function addMember (address member) external onlyOwner {
        whiteList[member] = true;
    }

     // delMember sólo accesible para el dueño del contrato   
    function delMember (address member) external onlyOwner {
        whiteList[member] = false;
    }

    function getInfo() external view returns (string memory) {
        return storedInfo;
    }
}