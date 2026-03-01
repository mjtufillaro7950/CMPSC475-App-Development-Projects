//
//  PieceView.swift
//  Pentominoes
//
//  Created by Michael Tufillaro on 2/27/26.
//

import SwiftUI


struct PieceView: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    let piece: Piece
    
    //computed properties that calculate the angle values for rotation
    var xRotationDegrees: Angle
    {
        //if its downMirrored, need to flip along X axis
        if piece.position.orientation == .downMirrored
        {
            return .degrees(180)
        }
        //otherwise, don't rotate
        else
        {
            return .degrees(0)
        }
    }
    var yRotationDegrees: Angle
    {
        switch piece.position.orientation
        {
            //need to flip around y axis if the orientation is up mirrored, left mirrored, or right mirrored
            case .upMirrored, .leftMirrored, .rightMirrored:
                return .degrees(180)
            //otherwise, don't rotate
            default:
                return .degrees(0)
        }
    }
    var zRotationDegrees: Angle
    {
        //rotate a different amount on the z axis depending on the orientation
        switch piece.position.orientation
        {
            case .up, .upMirrored, .downMirrored:
                return .degrees(0)
            case .right, .leftMirrored:
                return .degrees(90)
            case .down:
                return .degrees(180)
            case .left, .rightMirrored:
                return .degrees(270)
        }
    }
    
    var body: some View
    {
        //calculate the proper width and height of the piece based on the block size and the size of the piece
        let pieceWidth = manager.unitToViewCoord(coord: piece.outline.size.width)
        let pieceHeight = manager.unitToViewCoord(coord: piece.outline.size.height)
        //call helper func to get the position of the piece in terms of a CGPoint (non-unit values)
        let translatedPosition = manager.pieceToCGPoint(piece: piece)
        //make a pentominoView based on the Piece's outline, and sized correctly
        PentominoView(pentominoOutline: piece.outline)
            //size the piece depending on its width and height
            .frame(width: pieceWidth, height: pieceHeight)
            //Rotate along the different axes depending on the orientation
            .rotation3DEffect(xRotationDegrees, axis: (x: 1, y: 0, z: 0))
            .rotation3DEffect(yRotationDegrees, axis: (x: 0, y: 1, z: 0))
            .rotation3DEffect(zRotationDegrees, axis: (x: 0, y: 0, z: 1))
            //position the piece properly using the Piece's position value
            .position(translatedPosition)
        
    }
}


#Preview
{
    //PieceView()
}
