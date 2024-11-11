// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Final Work - Module 2 - Auction 
/// @author Sergio Muñoz
/// @notice This contract allows for the creation of an auction where participants can place bids.
/// @dev This is a simple auction implementation with time extensions, bid history, and deposit refunds.

contract AuctionSergiommm {
    // Structs
    struct Bid {
        address bidder;
        uint amount;
    }

    // State variables
    address public auctioneer;
    uint public endTime;
    uint32 public constant EXTENSION_PERIOD = 2 minutes;
    uint public minimumBid;
    uint8 public constant GAS_COMMISSION = 2; // 2%
    bool public auctionActive;
    Bid[] public bidHistory;

    // Events
    event NewBid(address indexed bidder, uint amount);
    event AuctionEnded(address winner, uint winningAmount);

    // Constructor
    constructor(uint _initialBid) {
        auctioneer = msg.sender;
        minimumBid = _initialBid;
        auctionActive = true;
        endTime = block.timestamp + EXTENSION_PERIOD;
        bidHistory.push(Bid(msg.sender, _initialBid));
    }

    // Modifiers
    modifier onlyAuctioneer() {
        require(msg.sender == auctioneer, "Only the auctioneer can execute this function");
        _;
    }

    modifier onlyWhileActive() {
        require(auctionActive, "The auction is not active");
        _;
    }

    // External functions
    function bid() external payable onlyWhileActive {
        uint currentMaxBid = getMaxBid();
        require(msg.value >= currentMaxBid * 105 / 100, "Bid must be at least 5% higher than the current bid");
        require(block.timestamp < endTime, "The auction has ended");

        // Extend the auction time
        endTime = block.timestamp + EXTENSION_PERIOD;

        bidHistory.push(Bid(msg.sender, msg.value));
        emit NewBid(msg.sender, msg.value);
    }

    function endAuction() external onlyAuctioneer {
        require(block.timestamp >= endTime, "The auction has not ended");

        auctionActive = false;
        Bid memory winningBid = bidHistory[bidHistory.length - 1];

        // Transfer winning amount to the auctioneer
        (bool success, ) = auctioneer.call{value: winningBid.amount}("");
        require(success, "Transfer to auctioneer failed");

        emit AuctionEnded(winningBid.bidder, winningBid.amount);
    }

    function refundDeposits() external onlyAuctioneer {
        require(!auctionActive, "The auction is still active");

        address winner = bidHistory[bidHistory.length - 1].bidder;

        for (uint i = 1; i < bidHistory.length - 1; i++) {
            Bid memory currentBid = bidHistory[i];
            if (currentBid.bidder != winner) {
                uint amountToRefund = currentBid.amount * (100 - GAS_COMMISSION) / 100;

                (bool success, ) = currentBid.bidder.call{value: amountToRefund}("");
                require(success, "Refund to bidder failed");
            }
        }
    }

    function partialWithdraw() external onlyWhileActive {
        uint amountToWithdraw = 0;

        for (uint i = 0; i < bidHistory.length - 1; i++) {
            if (bidHistory[i].bidder == msg.sender) {
                amountToWithdraw += bidHistory[i].amount;
                delete bidHistory[i];
            }
        }
        require(amountToWithdraw > 0, "There is nothing to withdraw");
        payable(msg.sender).transfer(amountToWithdraw);
    }

    function showBids() external view returns (Bid[] memory) {
        return bidHistory;
    }

    // Public functions
    function getMaxBid() public view returns (uint) {
        return bidHistory[bidHistory.length - 1].amount;
    }
}
