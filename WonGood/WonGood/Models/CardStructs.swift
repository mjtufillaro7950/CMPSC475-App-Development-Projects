//
//  CardStructs.swift
//  WonGood
//
//  Created by Michael Tufillaro on 4/22/26.
//

import Foundation
import SwiftUI

//structs for different options for card customization options

enum CardColor: String, Codable, CaseIterable
{
    case black
    case red
    case orange
    case yellow
    case green
    case blue
    case purple
    case gray
    
    //returns a Color for each cardColor
    var color: Color
    {
        switch self
        {
            case .black:    return Color.black
            case .red:      return Color.red
            case .orange:   return Color.orange
            case .yellow:   return Color( #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1) )
            case .green:    return Color.green
            case .blue:     return Color.blue
            case .purple:   return Color.purple
            case .gray:     return Color.gray
        }
    }
}

enum CardValue: String, Codable, CaseIterable
{
    case two    = "2"
    case three  = "3"
    case four   = "4"
    case five   = "5"
    case six    = "6"
    case seven  = "7"
    case eight  = "8"
    case nine   = "9"
    case ten    = "10"
    case jack   = "J"
    case queen  = "Q"
    case king   = "K"
    case ace    = "A"
    case funny = "67"
    
}

enum CardSuit: String, Codable, CaseIterable
{
    case spades
    case hearts
    case diamonds
    case clubs
    case stars
    case suns
    case moons
    case flames
    case shields
    case rads
    
    //returns the name of the system image corresponding to each suit
    var imageName: String
    {
        switch self
        {
            case .spades:       return "suit.spade.fill"
            case .hearts:       return "suit.heart.fill"
            case .diamonds:     return "suit.diamond.fill"
            case .clubs:        return "suit.club.fill"
            case .stars:        return "star.fill"
            case .suns:         return "sun.min.fill"
            case .moons:        return "moon.fill"
            case .flames:       return "flame.fill"
            case .shields:      return "shield.lefthalf.fill"
            case .rads:         return "burn"
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
    var sideSpacing:      CGFloat { return 0.19 * cardWidth }

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
