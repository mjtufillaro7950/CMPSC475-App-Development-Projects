//
//  SideEnum.swift
//  Pentominoes
//
//  Created by Michael Tufillaro on 2/26/26.
//

import Foundation
import SwiftUI


//enum to help determine which side of the SideView to build
enum Side
{
    case left
    case right
    
    //different switch statements that help determine layout of the left/right side of SideView
    var buttonText: String
    {
        switch self
        {
            case .left: return "Reset"
            case .right: return "Solve"
        }
    }
    
    var buttonColor: Color
    {
        switch self
        {
            case .left: return .purple
            case .right: return .green
        }
    }
    
    //TODO: figure out a way to make these values not be hardcoded?
    var loopIndex: (Int, Int)
    {
        switch self
        {
            case .left: return (0, 3)
            case .right: return (4, 7)
        }
    }
}
