// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SimpleDEX {
    address public tokenA;
    address public tokenB;
    uint256 public reserveA;
    uint256 public reserveB;
    address public owner;

    event LiquidityAdded(address indexed provider, uint256 amountA, uint256 amountB);
    event TokensSwapped(address indexed swapper, uint256 amountIn, uint256 amountOut, string direction);
    event LiquidityRemoved(address indexed provider, uint256 amountA, uint256 amountB);

    constructor(address _tokenA, address _tokenB) {
        tokenA = _tokenA;
        tokenB = _tokenB;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    function addLiquidity(uint256 amountA, uint256 amountB) external onlyOwner {
        IERC20(tokenA).transferFrom(msg.sender, address(this), amountA);
        IERC20(tokenB).transferFrom(msg.sender, address(this), amountB);
        reserveA += amountA;
        reserveB += amountB;
        emit LiquidityAdded(msg.sender, amountA, amountB);
    }

    function swapAforB(uint256 amountAIn) external {
        uint256 amountBOut = (amountAIn * reserveB) / (reserveA + amountAIn);
        IERC20(tokenA).transferFrom(msg.sender, address(this), amountAIn);
        IERC20(tokenB).transfer(msg.sender, amountBOut);
        reserveA += amountAIn;
        reserveB -= amountBOut;
        emit TokensSwapped(msg.sender, amountAIn, amountBOut, "A to B");
    }

    function swapBforA(uint256 amountBIn) external {
        uint256 amountAOut = (amountBIn * reserveA) / (reserveB + amountBIn);
        IERC20(tokenB).transferFrom(msg.sender, address(this), amountBIn);
        IERC20(tokenA).transfer(msg.sender, amountAOut);
        reserveB += amountBIn;
        reserveA -= amountAOut;
        emit TokensSwapped(msg.sender, amountBIn, amountAOut, "B to A");
    }

    function removeLiquidity(uint256 amountA, uint256 amountB) external onlyOwner {
        require(amountA <= reserveA && amountB <= reserveB, "Not enough liquidity");
        IERC20(tokenA).transfer(msg.sender, amountA);
        IERC20(tokenB).transfer(msg.sender, amountB);
        reserveA -= amountA;
        reserveB -= amountB;
        emit LiquidityRemoved(msg.sender, amountA, amountB);
    }

    function getPrice(address _token) external view returns (uint256) {
        if (_token == tokenA) {
            return (reserveB * 1e18) / reserveA;
        } else if (_token == tokenB) {
            return (reserveA * 1e18) / reserveB;
        } else {
            revert("Token not supported");
        }
    }
}
