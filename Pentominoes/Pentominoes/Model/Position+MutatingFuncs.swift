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
    mutating func rotateClockwise()
    {
        switch orientation
        {
            case .up: orientation = .right
            case .right: orientation = .down
            case .down: orientation = .left
            case .left: orientation = .up
            case .upMirrored: orientation = .rightMirrored
            case .rightMirrored: orientation = .downMirrored
            case .downMirrored: orientation = .leftMirrored
            case .leftMirrored: orientation = .upMirrored
        }
    }
    
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
