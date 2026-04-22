//
//  CardStructs.swift
//  WonGood
//
//  Created by Michael Tufillaro on 4/22/26.
//

import Foundation

//TODO: make a struct for different options for card customization options
    //start with value and color
    //right now, keep it to 2-A and Black/red, but update later


enum CardColor: String, Codable, CaseIterable
{
    case red
    case black
}

enum CardValue: String, Codable, CaseIterable
{
    case two   = "2"
    case three = "3"
    case four  = "4"
    case five  = "5"
    case six   = "6"
    case seven = "7"
    case eight = "8"
    case nine  = "9"
    case ten   = "10"
    case jack  = "J"
    case queen = "Q"
    case king  = "K"
    case ace   = "A"
}

enum CardSuit: String, Codable, CaseIterable
{
    case spades
    case hearts
    case diamonds
    case clubs
}

struct CardCustomizationOptions: Codable
{
    //default card option is the black jack of spades
    var color: CardColor = .black
    var value: CardValue = .jack
    var suit: CardSuit = .spades
}
