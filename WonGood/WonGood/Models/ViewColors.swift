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
    //HEX #497826
    static let tableColor = Color( #colorLiteral(red: 0.2862745098, green: 0.4705882353, blue: 0.1490196078, alpha: 1) )
    
    static let darkerTableColor = Color( #colorLiteral(red: 0.2319590336, green: 0.381302521, blue: 0.1207457983, alpha: 1) )
    
    static let screenColor = Color( #colorLiteral(red: 0.1814262424, green: 0.298234919, blue: 0.09444105765, alpha: 1) )
    //HEX #2B3853
    static let titleColor = Color( #colorLiteral(red: 0.168627451, green: 0.2196078431, blue: 0.3254901961, alpha: 1) )
    //HEX #acacac
    static let dealerGray = Color( #colorLiteral(red: 0.6745098039, green: 0.6745098039, blue: 0.6745098039, alpha: 1) )
    
    //dealer gray is #acacac
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
