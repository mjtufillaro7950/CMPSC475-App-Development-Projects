//
//  MiddleView.swift
//  Pentominoes
//
//  Created by Michael Tufillaro on 2/26/26.
//

import SwiftUI

struct MiddleView: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    
    //computed properties that calculate the height and width of the grid in non-unit CGFloats
    var gridWidth: CGFloat
    {
        return manager.unitToViewCoord(coord: manager.numRows)
    }
    
    var gridHeight: CGFloat
    {
        return manager.unitToViewCoord(coord: manager.numCols)
    }
    var body: some View
    {
        VStack
        {
            //TODO: make title look fancy
            Text("PENTOMINOES")
            //TODO: pieces need to be within this ZStack somehow
            ZStack(alignment: .topLeading)
            {
                //TODO: make this look pretty
                GridShape(gridRows: CGFloat(manager.numRows), gridColumns: CGFloat(manager.numCols))
                    .stroke(.black, lineWidth: 1)
                    .frame(width: gridWidth, height: gridHeight)
                
                //for each outline, make a pentomino shape
                ForEach(manager.pieces, id: \.outline.name)
                {
                    piece in
                    PieceView(piece: piece)
                }
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    MiddleView()
        .environment(ViewModel())
}
