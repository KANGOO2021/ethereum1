// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SimpleDEX {
    address public tokenA;
    address public tokenB;

    uint256 public reserveA;
    uint256 public reserveB;

    event LiquidityAdded(uint256 amountA, uint256 amountB);
    event TokensSwapped(address indexed user, uint256 amountIn, uint256 amountOut, string direction);
    event LiquidityRemoved(uint256 amountA, uint256 amountB);

    constructor(address _tokenA, address _tokenB) {
        tokenA = _tokenA;
        tokenB = _tokenB;
    }

    // Añadir liquidez
    function addLiquidity(uint256 amountA, uint256 amountB) external {
        require(amountA > 0 && amountB > 0, "Amounts must be greater than zero");

        // Transferir los tokens al contrato
        IERC20(tokenA).transferFrom(msg.sender, address(this), amountA);
        IERC20(tokenB).transferFrom(msg.sender, address(this), amountB);

        // Actualizar reservas
        reserveA += amountA;
        reserveB += amountB;

        emit LiquidityAdded(amountA, amountB);
    }

    // Intercambiar TokenA por TokenB
    function swapAforB(uint256 amountAIn) external {
        require(amountAIn > 0, "Amount must be greater than zero");
        require(reserveA > 0 && reserveB > 0, "Insufficient liquidity");

        // Calcular cantidad de TokenB a recibir usando la fórmula del producto constante
        uint256 amountBOut = (reserveB * amountAIn) / (reserveA + amountAIn);

        require(amountBOut > 0, "Output amount must be greater than zero");

        // Transferir TokenA al contrato
        IERC20(tokenA).transferFrom(msg.sender, address(this), amountAIn);

        // Transferir TokenB al usuario
        IERC20(tokenB).transfer(msg.sender, amountBOut);

        // Actualizar reservas
        reserveA += amountAIn;
        reserveB -= amountBOut;

        emit TokensSwapped(msg.sender, amountAIn, amountBOut, "A->B");
    }

    // Intercambiar TokenB por TokenA
    function swapBforA(uint256 amountBIn) external {
        require(amountBIn > 0, "Amount must be greater than zero");
        require(reserveA > 0 && reserveB > 0, "Insufficient liquidity");

        // Calcular cantidad de TokenA a recibir usando la fórmula del producto constante
        uint256 amountAOut = (reserveA * amountBIn) / (reserveB + amountBIn);

        require(amountAOut > 0, "Output amount must be greater than zero");

        // Transferir TokenB al contrato
        IERC20(tokenB).transferFrom(msg.sender, address(this), amountBIn);

        // Transferir TokenA al usuario
        IERC20(tokenA).transfer(msg.sender, amountAOut);

        // Actualizar reservas
        reserveA -= amountAOut;
        reserveB += amountBIn;

        emit TokensSwapped(msg.sender, amountBIn, amountAOut, "B->A");
    }

    // Retirar liquidez
    function removeLiquidity(uint256 amountA, uint256 amountB) external {
        require(amountA > 0 && amountB > 0, "Amounts must be greater than zero");
        require(amountA <= reserveA && amountB <= reserveB, "Insufficient reserves");

        // Transferir los tokens al propietario
        IERC20(tokenA).transfer(msg.sender, amountA);
        IERC20(tokenB).transfer(msg.sender, amountB);

        // Actualizar reservas
        reserveA -= amountA;
        reserveB -= amountB;

        emit LiquidityRemoved(amountA, amountB);
    }

    // Consultar precio
    function getPrice(address _token) external view returns (uint256) {
        require(_token == tokenA || _token == tokenB, "Invalid token address");
        if (_token == tokenA) {
            return (reserveB * 1e18) / reserveA; // Precio de TokenA en términos de TokenB
        } else {
            return (reserveA * 1e18) / reserveB; // Precio de TokenB en términos de TokenA
        }
    }
}
