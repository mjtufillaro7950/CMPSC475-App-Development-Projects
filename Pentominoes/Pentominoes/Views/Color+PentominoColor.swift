//
//  Color+PentominoColor.swift
//  Pentominoes
//
//  Created by Michael Tufillaro on 2/27/26.
//

import SwiftUI


//extends color to return a specific color when given a pentomino outline
extension Color
{
    init(pentominoOutline: PentominoOutline)
    {
        switch pentominoOutline.name
        {
            case "X": self = .red
                
            case "P": self = .green
                
            case "F": self = .blue
                
            case "W": self = .yellow
                
            case "Z": self = .cyan
                
            case "U": self = .indigo
                
            case "V": self = .mint
                
            case "T": self = .orange
                
            case "L": self = .pink
                
            case "Y": self = .teal
                
            case "N": self = .gray
                
            case "I": self = .purple
            
            default:
                print("Error! Wrong Name for Outline")
                self = .black
        }
    }
}
