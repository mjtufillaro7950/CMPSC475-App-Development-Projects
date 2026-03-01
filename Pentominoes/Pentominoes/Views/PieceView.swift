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
            case .right, .rightMirrored:
                return .degrees(90)
            case .down:
                return .degrees(180)
            case .left, .leftMirrored:
                return .degrees(270)
        }
    }
    
    //state var for handling dragging
    @State private var dragOffset: CGSize = .zero
    @State private var isDragging: Bool = false
    
    var body: some View
    {
        //call helper func to get the position of the piece in terms of a CGPoint (non-unit values)
        let translatedPosition = manager.pieceToCGPoint(piece: piece)
        
        //Handle drag (mostly copied from class code)
        let dragGesture = DragGesture()
            .onChanged
            {
                value in
                
                withAnimation
                {
                    isDragging = true
                }
                
                dragOffset = value.translation
                //call viewmodel to start drag
                manager.startDrag(piece: piece)
            }
            .onEnded
            {
                value in
                withAnimation
                {
                    isDragging = false
                }
                
                //calculate the end position and call endDrag
                let finalX = translatedPosition.x + value.translation.width
                let finalY = translatedPosition.y + value.translation.height
                let finalPoint = CGPoint(x: finalX, y: finalY)
                manager.endDrag(at: finalPoint)
                //reset Offset to 0
                dragOffset = .zero
            }
        
        //handle tap
        let tapGesture = TapGesture()
            .onEnded
            {
                //need to adjust the index of the Piece in viewmodel, then reset when done
                manager.draggedPieceIndex = manager.getPieceIndex(piece: piece)
                //do rotation with animation
                withAnimation(.easeIn(duration: 0.5))
                {
                    manager.rotatePiece(piece: piece)
                }
                manager.draggedPieceIndex = -1
            }
        
        //handle long press
        let longPressGesture = LongPressGesture(minimumDuration: 0.5)
            .onEnded
            {
                //as far as I can tell I don't need this value here but it threw a fit if I didn't include it
                idk in
                manager.draggedPieceIndex = manager.getPieceIndex(piece: piece)
                //do flip with animation
                withAnimation(.easeIn(duration: 0.5))
                {
                    manager.flipPiece(piece: piece)
                }
                manager.draggedPieceIndex = -1
            }
        
        //drag gesture takes priority, then long press, then tap
        let combinedGesture = dragGesture.exclusively(before: longPressGesture.exclusively(before: tapGesture))
        
        //calculate the proper width and height of the piece based on the block size and the size of the piece
        let pieceWidth = manager.unitToViewCoord(coord: piece.outline.size.width)
        let pieceHeight = manager.unitToViewCoord(coord: piece.outline.size.height)
        
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
            //ensures the piece is animated in real time instead of snapping
            .offset(dragOffset)
            //while dragging, the piece should be scaled up 20%
            .scaleEffect(isDragging ? 1.2 : 1)
            //this ensure the piece goes over other pieces while being dragged
            .zIndex(isDragging ? 100 : 0)
            //add the gestures so tapping/dragging/long pressing works
            .gesture(combinedGesture)
            //make the piece transparent if its in the proper location for the current puzzle
            .opacity(manager.isInSolutionPosition(piece: piece) ? 0.5 : 1)
    }
}


#Preview
{
    //PieceView()
}
