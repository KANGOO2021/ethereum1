// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Auction {
    address public auctioneer;
    uint public endTime;
    uint public minimumBid;
    uint public gasCommission = 2; // 2%
    bool public auctionActive;
    address public highestBidder;
    uint public highestBid;

    event NewBid(address indexed bidder, uint amount);
    event AuctionEnded(address winner, uint winningAmount);

    constructor(uint _initialBid) {
        auctioneer = msg.sender;
        minimumBid = _initialBid;
        auctionActive = true;
        endTime = block.timestamp + 1 days; // Fijar duración de la subasta
        highestBidder = msg.sender;
        highestBid = _initialBid;
    }

    modifier onlyAuctioneer() {
        require(msg.sender == auctioneer, "Only the auctioneer can execute this function");
        _;
    }

    modifier onlyWhileActive() {
        require(auctionActive, "The auction is not active");
        _;
    }

    function bid() external payable onlyWhileActive {
        require(msg.value >= (highestBid * 105) / 100, "The bid must be at least 5% higher than the current bid");
        require(block.timestamp < endTime, "The auction has ended");

        // Refund the previous highest bidder
        if (highestBidder != address(0)) {
            uint refundAmount = (highestBid * (100 - gasCommission)) / 100;
            (bool success, ) = highestBidder.call{value: refundAmount}("");
            require(success, "Refund to previous highest bidder failed");
        }

        // Update the highest bid and bidder
        highestBidder = msg.sender;
        highestBid = msg.value;
        emit NewBid(msg.sender, msg.value);
    }

    function endAuction() external onlyAuctioneer {
        require(block.timestamp >= endTime, "The auction has not ended");
        require(auctionActive, "Auction already ended");

        auctionActive = false;
        emit AuctionEnded(highestBidder, highestBid);
    }

    function withdraw() external onlyAuctioneer {
        require(!auctionActive, "The auction is still active");

        // Auctioneer can withdraw the highest bid amount minus the commission
        uint amountToAuctioneer = (highestBid * (100 - gasCommission)) / 100;
        payable(auctioneer).transfer(amountToAuctioneer);
    }
}
