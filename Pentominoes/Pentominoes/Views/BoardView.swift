//
//  BoardView.swift
//  Pentominoes
//
//  Created by LiasPub on 3/1/26.
//

import SwiftUI


//view that generates the board, which consists of a grid with a puzzle shape on top of it
struct BoardView: View
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
    
    //computed properties to get the current puzzle outline, and then the width/height of the PuzzleShape
    var currentPuzzleOutline: PuzzleOutline
    {
        return manager.getPuzzleOutlineFromName(puzzleName: manager.selectedPuzzle)
    }
    
    var puzzleWidth: CGFloat
    {
        return manager.unitToViewCoord(coord: currentPuzzleOutline.size.width)
    }
    
    var puzzleHeight: CGFloat
    {
        return manager.unitToViewCoord(coord: currentPuzzleOutline.size.height)
    }
    
    var body: some View
    {
        ZStack
        {
            //TODO: make this look pretty
            GridShape(gridRows: CGFloat(manager.numRows), gridColumns: CGFloat(manager.numCols))
                .stroke(.black, lineWidth: 1)
                .frame(width: gridWidth, height: gridHeight)
            
            //overlay the PuzzleShape for the currently selected puzzle
            if manager.selectedPuzzle != "blank"
            {
                let puzzleOutline = manager.getPuzzleOutlineFromName(puzzleName: manager.selectedPuzzle)
                PuzzleShape(puzzleOutline: puzzleOutline)
                    .fill(
                        //make the puzzle shape have half opacity so you can see the grid under it
                        Color.gray.opacity(0.5),
                        //use odd/even filling style to properly render the inner shapes of the puzzle
                        style: FillStyle(eoFill: true)
                    )
                    .frame(width: puzzleWidth, height: puzzleHeight)
                
            }
        }
    }
}

#Preview {
    BoardView()
        .environment(ViewModel())
}
