//
//  ViewModel+CoreGraphics.swift
//  Pentominoes
//
//  Created by Michael Tufillaro on 2/27/26.
//

import Foundation
//import CoreGraphics to be able to use CGPoint, CGFloat, etc
import CoreGraphics

extension ViewModel
{
    //convert a unit coordinate to a view coordinate
    func unitToViewCoord(coord: Int) -> CGFloat
    {
        return CGFloat(coord) * self.blockSize
    }
    
    //TODO: function that takes in a Position and returns a CGPoint
}
