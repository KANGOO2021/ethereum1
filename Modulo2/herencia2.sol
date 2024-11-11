// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Contrato de nivel base
contract Grandparent {
    uint public grandparentValue;

    constructor(uint _value) {
        grandparentValue = _value;
    }

    function setGrandparentValue(uint _value) public {
        grandparentValue = _value;
    }
}

// Primer nivel de herencia
contract Parent is Grandparent {
    uint public parentValue;

    constructor(uint _grandparentValue, uint _parentValue) Grandparent(_grandparentValue) {
        parentValue = _parentValue;
    }

    function setParentValue(uint _value) public {
        parentValue = _value;
    }
}

// Segundo nivel de herencia
contract Child is Parent {
    uint public childValue;

    constructor(uint _grandparentValue, uint _parentValue, uint _childValue) Parent(_grandparentValue, _parentValue) {
        childValue = _childValue;
    }

    function setChildValue(uint _value) public {
        childValue = _value;
    }
}