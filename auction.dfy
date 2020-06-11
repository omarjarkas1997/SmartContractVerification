include "contract.dfy"

class Auction extends address {


  var beneficiary: address
  var auctionEnd: nat
  var highestBidder: address?
  var highestBid: nat
  var pendingReturns: map<address, nat>
  var ended: bool



  constructor(biddingTime: nat, seller: address, block: Block)
    ensures beneficiary == seller && auctionEnd == block.timestamp + biddingTime
    {
      beneficiary := seller;
      auctionEnd := block.timestamp + biddingTime;
      highestBidder := null;
      highestBid := 0;
      ended := false;
      pendingReturns := map[];
    }
  
  method bid(bidder: address)
    requires block.timestamp <= auctionEnd
    requires msg.value > highestBid
    requires highestBidder != msg.sender
    modifies this
    {
      // if highest bid is not zero, this means that their is atleast an initial bid in the contract
      if highestBid != 0 {
        // before we assign the new bidder we must return the latest bid to the previous person
        // if the bider that we want to return the money to is in the map, add the the leastest money to him in not create an element if the map and add the money to it 
        pendingReturns := pendingReturns[highestBidder:= (if highestBidder in pendingReturns then pendingReturns[highestBidder] else 0) + highestBid];
      }
      // assign the new highest bidder and the new highest bid
      highestBidder := bidder.msg.sender;
      highestBid := bidder.msg.value;
    }

    method withdraw(caller: address) returns (r: bool)
    ensures caller.msg.sender in pendingReturns ==> pendingReturns[caller.msg.sender] == 0
    ensures 
      {
        var amount := if caller.msg.sender in pendingReturns then pendingReturns[caller.msg.sender] else 0;

      } 


    

  
}