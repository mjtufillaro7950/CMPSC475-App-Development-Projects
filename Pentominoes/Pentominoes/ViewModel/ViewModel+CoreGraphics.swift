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
    
    
    //function that takes in a Piece and returns a CGPoint representing its location, centered to the middle of the piece
    func pieceToCGPoint(piece: Piece) -> CGPoint
    {
        //calculate the top left of the rectangle that contains the piece
        let topLeftX = self.unitToViewCoord(coord: piece.position.x)
        let topRightY = self.unitToViewCoord(coord: piece.position.y)
        
        //calculate the height and width of the Piece
        var pieceHeight: CGFloat
        var pieceWidth: CGFloat
        
        switch piece.position.orientation
        {
            //if the piece is on its side, the height and width are swapped
            case .left, .right, .leftMirrored, .rightMirrored:
                pieceWidth = unitToViewCoord(coord: piece.outline.size.height)
                pieceHeight = unitToViewCoord(coord: piece.outline.size.width)
            //otherwise, the height and width are normal
            default:
                pieceHeight = unitToViewCoord(coord: piece.outline.size.height)
                pieceWidth = unitToViewCoord(coord: piece.outline.size.width)
            
        }
        //calculate the center of the piece view
        let centerX = topLeftX + (pieceWidth / 2)
        let centerY = topRightY + (pieceHeight / 2)
        
        return CGPoint(x: centerX, y: centerY)
    }
}
