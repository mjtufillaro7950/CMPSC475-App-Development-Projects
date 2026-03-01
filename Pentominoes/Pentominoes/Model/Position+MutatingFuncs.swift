//
//  Position+MutatingFuncs.swift
//  Pentominoes
//
//  Created by Michael Tufillaro on 3/1/26.
//

import Foundation

//extend position with mutating funcs to change orientation
extension Position
{
    //if rotating clockwise, switch to next orientaton
    mutating func rotateClockwise()
    {
        switch orientation
        {
            case .up: orientation = .right
            case .right: orientation = .down
            case .down: orientation = .left
            case .left: orientation = .up
            case .upMirrored: orientation = .leftMirrored
            case .leftMirrored: orientation = .downMirrored
            case .downMirrored: orientation = .rightMirrored
            case .rightMirrored: orientation = .upMirrored
        }
    }
    
    //if flipping, swap to opposite orientation
    mutating func flip()
    {
        switch orientation
        {
            case .up: orientation = .upMirrored
            case .right: orientation = .rightMirrored
            case .down: orientation = .downMirrored
            case .left: orientation = .leftMirrored
            case .upMirrored: orientation = .up
            case .rightMirrored: orientation = .right
            case .downMirrored: orientation = .down
            case .leftMirrored: orientation = .left
            
        }
    }
}
