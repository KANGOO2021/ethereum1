// SPDX-License-Identifier: MIT
pragma solidity >0.7.0 <0.9.0;

/// @title Final Work - Module 2 - Auction 
/// @notice This contract allows for the creation of an auction where participants can place bids in gwei only.
/// @dev This is a simple auction implementation with time extensions, bid history, and deposit refunds.

contract AuctionSergiooonnn {
    // Structs
    struct Bid {
        address bidder;
        uint amountGwei; // Changed to represent amount in gwei
    }

    // State variables
    address public auctioneer;
    uint public endTime;
    uint32 public extensionPeriod = 2 minutes;
    uint public minimumBidGwei; // Minimum bid in gwei
    uint8 public gasCommission = 2; // 2%
    bool public auctionActive;
    Bid[] public bidHistory;

    // Events
    event NewBid(address indexed bidder, uint amountGwei);
    event AuctionEnded(address winner, uint winningAmountGwei);

    // Constructor
    constructor(uint _initialBidGwei) {
        auctioneer = msg.sender;
        minimumBidGwei = _initialBidGwei;
        auctionActive = true;
        endTime = block.timestamp + extensionPeriod;
        bidHistory.push(Bid(msg.sender, _initialBidGwei));
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
        uint bidAmountGwei = msg.value / 1 gwei;
        require(bidAmountGwei >= (getMaxBidGwei() * 105) / 100, "The bid must be at least 5% higher than the current bid");
        require(block.timestamp < endTime, "The auction has ended");

        // Extend the auction time
        endTime += extensionPeriod;

        bidHistory.push(Bid(msg.sender, bidAmountGwei));
        emit NewBid(msg.sender, bidAmountGwei);
    }

    function endAuction() external onlyAuctioneer {
        require(block.timestamp >= endTime, "The auction has not ended");

        auctionActive = false;
        address winner = bidHistory[bidHistory.length - 1].bidder;
        uint winningAmountGwei = bidHistory[bidHistory.length - 1].amountGwei;

        // Transfer winning amount in wei to the auctioneer
        uint winningAmountWei = winningAmountGwei * 1 gwei;
        (bool success, ) = auctioneer.call{value: winningAmountWei}("");
        require(success, "Transfer to auctioneer failed");

        emit AuctionEnded(winner, winningAmountGwei);
    }

    function refundDeposits() external onlyAuctioneer {
        require(!auctionActive, "The auction is still active");

        uint historialArray = bidHistory.length;
        address winner = bidHistory[historialArray - 1].bidder;

        for (uint i = 1; i < historialArray - 1; i++) { // Excluding the last bid (winner)
            address bidder = bidHistory[i].bidder;
            uint amountGwei = bidHistory[i].amountGwei;

            // Skip refund if the bidder is the winner
            if (bidder == winner) {
                continue;
            }

            // Calculate the amount after deducting the 2% commission
            uint amountToRefundGwei = (amountGwei * (100 - gasCommission)) / 100;
            uint amountToRefundWei = amountToRefundGwei * 1 gwei;

            // Use 'call' for refund, instead of 'transfer'
            (bool success, ) = bidder.call{value: amountToRefundWei}("");
            require(success, "Refund to bidder failed");
        }
    }

    function partialWithdraw() external onlyWhileActive {
        uint amountToWithdrawGwei = 0;
        uint historialArray = bidHistory.length;

        for (uint i = 0; i < historialArray - 1; i++) {
            if (bidHistory[i].bidder == msg.sender) {
                amountToWithdrawGwei += bidHistory[i].amountGwei;
                delete bidHistory[i]; // Remove bid
            }
        }
        require(amountToWithdrawGwei > 0, "There is nothing to withdraw");

        uint amountToWithdrawWei = amountToWithdrawGwei * 1 gwei;
        payable(msg.sender).transfer(amountToWithdrawWei);
    }

    function showBids() external view returns (Bid[] memory) {
        return bidHistory;
    }

    // Public functions
    function getMaxBidGwei() public view returns (uint) {
        return bidHistory[bidHistory.length - 1].amountGwei;
    }
}
