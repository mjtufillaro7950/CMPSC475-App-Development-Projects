//
//  PieceView.swift
//  Pentominoes
//
//  Created by Michael Tufillaro on 2/27/26.
//

import SwiftUI


//TODO: pass in a Piece, make a PentominoView, sized properly. Position based on the piece's Position property, converting from unit coordinates to view  coordinates (in viewmodel)?
struct PieceView: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    let piece: Piece
    
    var body: some View
    {
        //calculate the proper width and height of the piece based on the block size and the size of the piece
        let pieceWidth = manager.unitToViewCoord(coord: piece.outline.size.width)
        let pieceHeight = manager.unitToViewCoord(coord: piece.outline.size.height)
        //call helper func to get the position of the piece in terms of a CGPoint (non-unit values)
        let translatedPosition = manager.pieceToCGPoint(piece: piece)
        //make a pentominoView based on the Piece's outline, and sized correctly
        PentominoView(pentominoOutline: piece.outline)
            .frame(width: pieceWidth, height: pieceHeight)
            .position(translatedPosition)
        //TODO: figure out how to rotate pieces if the orientation is different
    }
}


#Preview
{
    //PieceView()
}
