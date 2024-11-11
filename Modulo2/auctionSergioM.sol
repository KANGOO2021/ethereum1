// SPDX-License-Identifier: MIT
pragma solidity > 0.7.0 < 0.9.0;

/// @title Final Work - Module 2 - Auction 
/// @author Sergio Muñoz
/// @notice This contract allows for the creation of an auction where participants can place bids.
/// @dev This is a simple auction implementation with time extensions, bid history, and deposit refunds.

contract AuctionSergioM {
    // Structs
    struct Bid {
        address bidder;
        uint amount;
    }

    // State variables
    address public auctioneer;
    uint public endTime;
    uint32 public constant EXTENSION_PERIOD = 10 minutes;
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
        require(msg.value >= (getMaxBid() * 105) / 100, "The bid must be at least 5% higher than the current bid");
        require(block.timestamp < endTime, "The auction has ended");

        // Extend the auction time only if the bid is made within the last 10 minutes of the auction
        if (endTime - block.timestamp <= EXTENSION_PERIOD) {
            endTime += EXTENSION_PERIOD;
        }

        bidHistory.push(Bid(msg.sender, msg.value));
        emit NewBid(msg.sender, msg.value);
    }



    function endAuction() external onlyAuctioneer {
        require(block.timestamp >= endTime, "The auction has not ended");

        auctionActive = false;
        address winner = bidHistory[bidHistory.length - 1].bidder;
        uint winningAmount = bidHistory[bidHistory.length - 1].amount;

        // Transfer winning amount to the auctioneer
        (bool success, ) = auctioneer.call{value: winningAmount}("");
        require(success, "Transfer to auctioneer failed");

        emit AuctionEnded(winner, winningAmount);
    }

    function refundDeposits() external onlyAuctioneer {
        require(!auctionActive, "The auction is still active");

        uint historialArray = bidHistory.length;
        address winner = bidHistory[historialArray - 1].bidder;

        for (uint i = 1; i < historialArray - 1; i++) { // Excluding the last bid (winner)
            address bidder = bidHistory[i].bidder;
            uint amount = bidHistory[i].amount;

            // Skip refund if the bidder is the winner
            if (bidder == winner) {
                continue;
            }

            // Calculate the amount after deducting the 2% commission
            uint amountToRefund = (amount * (100 - GAS_COMMISSION)) / 100;

            // Use 'call' for refund, instead of 'transfer'
            (bool success, ) = bidder.call{value: amountToRefund}("");
            require(success, "Refund to bidder failed");
        }
    }

    function partialWithdraw() external onlyWhileActive {
        uint amountToWithdraw = 0;
        uint historialArray = bidHistory.length;

        for (uint i = 0; i < historialArray - 1; i++) {
            if (bidHistory[i].bidder == msg.sender) {
                amountToWithdraw += bidHistory[i].amount;
                delete bidHistory[i]; // Remove bid
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
