//
//  DealerQuotes.swift
//  WonGood
//
//  Created by Michael Tufillaro on 4/29/26.
//

import Foundation

extension GameSessionManager
{
    //returns a random dealer quote for use in the shuffle phase
    func randomDealerQuote() -> String
    {
        return Self.dealerQuotes.randomElement()!
    }
    
    //list of all dealer quotes
    private static let dealerQuotes: [String] =
    [
        "Let's see if YOU'VE WonGood...",
        "The cards never lie.",
        "Read 'em and weep.",
        "Fortune favors the bold.",
        "Keep your friends close and your cards closer...",
        "Are you all in? Or all out?",
        "All bets are final.",
        "This deserves a good grade, right?",
        "Don't forget to tip your dealer!",
        "Poker? I hardly know 'er!",
        "Lotta bugs around here. I gotta hire an exterminator.",
        "This is some GRADE A dealing, huh?"
    ]
}

