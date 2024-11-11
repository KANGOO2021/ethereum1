// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;


import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    constructor() ERC20("MyToken", "MTK") {
        _mint(msg.sender, 1000 * (10 ** uint256(decimals())));
    }
}