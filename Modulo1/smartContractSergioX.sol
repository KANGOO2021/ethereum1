// SPDX-License-Identifier: MIT
pragma solidity > 0.7.0 < 0.9.0;

contract smartContractSergioX {

    string private storedMessage;
   

    function getInfoSergioX() public view returns (string memory) {

        return storedMessage;
    }

    function setInfoSergioX(string calldata myMessage) public {
        
        storedMessage = myMessage;

    }

   
}