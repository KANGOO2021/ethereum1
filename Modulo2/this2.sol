// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface OtherContract {
    function someFunction(address caller) external;
}

contract MyContract {
    OtherContract otherContract;

    constructor(address _otherContractAddress) {
        otherContract = OtherContract(_otherContractAddress);
    }

    function callOtherContractFunction() public {
        // Pasar la dirección de este contrato a otra función de contrato
        otherContract.someFunction(address(this));
    }
}