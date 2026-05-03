//
//  ViewColors.swift
//  WonGood
//
//  Created by MichaelTufillaro on 4/16/26.
//

import Foundation
import SwiftUI


//extend color to add values relevant to my views
extension Color
{
    static let tableColor = Color( #colorLiteral(red: 0.01568627451, green: 0.4235294118, blue: 0.3333333333, alpha: 1) )
    static let darkerTableColor = Color( #colorLiteral(red: 0.01314903276, green: 0.3550238846, blue: 0.2794169462, alpha: 1) )
    static let screenColor = Color( #colorLiteral(red: 0.01198965697, green: 0.3237207383, blue: 0.2547802107, alpha: 1) )
    
    //HEX #2B3853
    static let titleColor = Color( #colorLiteral(red: 0.168627451, green: 0.2196078431, blue: 0.3254901961, alpha: 1) )
    //HEX #acacac
    static let dealerGray = Color( #colorLiteral(red: 0.6745098039, green: 0.6745098039, blue: 0.6745098039, alpha: 1) )
}

extension LinearGradient
{
    static var tableGradient: LinearGradient
    {
        //make a gradient that holds the solid color until halfway down to make the dealer view and content views seamless
        return LinearGradient(
            gradient: Gradient(stops: [
                .init(color: .tableColor,       location: 0.0),
                .init(color: .tableColor,       location: 0.5),
                .init(color: .darkerTableColor, location: 1.0)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
