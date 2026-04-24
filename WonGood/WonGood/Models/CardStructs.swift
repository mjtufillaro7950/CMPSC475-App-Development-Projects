//
//  CardStructs.swift
//  WonGood
//
//  Created by Michael Tufillaro on 4/22/26.
//

import Foundation
import SwiftUI

//TODO: make a struct for different options for card customization options
    //start with value and color
    //right now, keep it to 2-A and Black/red, but update later

enum CardColor: String, Codable, CaseIterable
{
    case red
    case black
    
    //returns a Color for each cardColor
    var color: Color
    {
        switch self
        {
            case .red:   return Color.red
            case .black: return Color.black
        }
    }
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
    //TODO: optionally, add fun different suits like a star, sun, moon, eye, cloud, tortise, smiley, flame, gamecontroller, shield.lefthalf, globe, burn, bitcoinsign.square
    //TODO: make suit correspond to color like how it works in the real world? if thats the case, I can get rid of CardColor and simplify things
    case spades
    case hearts
    case diamonds
    case clubs
    
    //returns the name of the system image corresponding to each suit
    var imageName: String
    {
        switch self
        {
            case .spades:   return "suit.spade.fill"
            case .hearts:   return "suit.heart.fill"
            case .diamonds: return "suit.diamonds.fill"
            case .clubs:    return "suit.club.fill"
        }
    }
}


//calculate/store the relevant sizes of the different parts of the card views as a function of card width
struct CardLayout
{
    let cardWidth: CGFloat

    var cardCornerRadius: CGFloat { return cardWidth / 15 }
    var cardStrokeWidth:  CGFloat { return cardWidth / 20 }
    var cardHeight:       CGFloat { return 1.4 * cardWidth }
    var shadowRadius:     CGFloat { return 0.08 * cardWidth }
    var paddingSize:      CGFloat { return 0.05 * cardWidth }

    //subtle off-white linear gradient for card  color
    var cardGradient: LinearGradient
    {
        let cardColorOne = Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        let cardColorTwo = Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
        return LinearGradient(
            gradient: Gradient(colors: [cardColorOne, cardColorTwo]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}


struct CardCustomizationOptions: Codable
{
    //default card option is the black jack of spades
    var color: CardColor = .black
    var value: CardValue = .jack
    var suit: CardSuit = .spades
}
