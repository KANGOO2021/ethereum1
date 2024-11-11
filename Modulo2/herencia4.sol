// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A {
    function foo() public pure returns(string memory) {
        return "A";
    }
}

contract B {
    function bar() public pure returns(string memory) {
        return "B";
    }
}

contract C is A, B {
    function fooBar() public pure returns(string memory) {
        return string(abi.encodePacked(foo(), bar()));
    }
}