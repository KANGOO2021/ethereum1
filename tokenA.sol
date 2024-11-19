// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract TokenA is ERC20 {
    constructor() ERC20("TokenA", "TKA") {
        // Suministro inicial: 1000 tokens con 18 decimales
        _mint(msg.sender, 10000 * 10**decimals());
    }
}
