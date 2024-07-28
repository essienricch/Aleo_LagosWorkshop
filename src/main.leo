program tianaholaoluwa.aleo {
    // A bid in an auction.
    // - `owner`     : The address of the account that owns the record associated with this bid.
    //                 This is separate from the address of the account that placed the bid.
    // - `bidder`    : The address of the account that placed the bid.
    // - `amount`    : The amount of the bid.
    // - `is_winner` : Whether the bid is the winning bid.
    record Bik {
        owner: address,
        bidder: address,
        amount: u64,
        is_winner: bool,
    }

    // Returns a new bid.
    // - `bidder` : The address of the account that placed the bid.
    // - `amount` : The amount of the bid.
    // Requires that `bidder` matches the function caller.
    // The owner of the record is set to the entity responsible for running the auction (auction runner).
    // The address of the auction runner is aleo1ashyu96tjwe63u0gtnnv8z5lhapdu4l5pjsl2kha7fv7hvz2eqxs5dz0rg.
    transition place_bid(bidder: address, amount: u64) -> Bik {
        // Ensure the caller is the auction bidder.
        assert_eq(self.caller, bidder);
        // Return a new 'Bik' record for the auction bidder.
        return Bik {
            owner: aleo18lp7axmhvgj2slpqp96v3hvh6r2cfqx5n4u80etp3lgp79yt3q9sv6d4qj,
            bidder: bidder,
            amount: amount,
            is_winner: false,
        };
    }

    // Returns the winning bid.
    // - `first`  : The first bid.
    // - `second` : The second bid.
    // Requires that the function caller is the auction runner.
    // Assumes that the function is invoked only after the bidding period has ended.
    // In the event of a tie, the first bid is selected.
    transition resolve(first: Bik, second: Bik) -> Bik {
        // Ensure the caller is the auctioneer.
        assert_eq(self.caller, aleo18lp7axmhvgj2slpqp96v3hvh6r2cfqx5n4u80etp3lgp79yt3q9sv6d4qj);
        // Resolve the winner of the auction.
        if (first.amount >= second.amount) {
            return first;
        } else {
            return second;
        }
    }

    // Returns ownership of the bid to bidder.
    // - `bid` : The winning bid.
    // Requires that the function caller is the auction runner.
    // Assumes that the function is invoked only after all bids have been resolved.
    transition finish(bid: Bik) -> Bik {
        // Ensure the caller is the auctioneer.
        assert_eq(self.caller, aleo18lp7axmhvgj2slpqp96v3hvh6r2cfqx5n4u80etp3lgp79yt3q9sv6d4qj);
        // Return 'is_winner' as 'true' in the winning 'Bik'.
        return Bik {
            owner: bid.bidder,
            bidder: bid.bidder,
            amount: bid.amount,
            is_winner: true,
        };
    }
}
