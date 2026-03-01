//
//  ViewModel.swift
//  Pentominoes
//
//  Created by Michael Tufillaro on 2/24/26.
//

import Foundation

//create viewmodel manager
@Observable
class ViewModel
{
    //create an array of pieces and outlines which essentially serve as the model for the app
    var pieces: [Piece] = []
    var pentominoOutlines: [PentominoOutline] = []
    var puzzleOutlines: [PuzzleOutline] = []
    //The solutions in the provided JSON file are formatted as dictionaries mapping a puzzle name to its solutions, which are a dict mapping a piece name to its correct position
    var solutions: [String: [String: Position]] = [:]
    
    //set a consistent block size of 40 units to be used in all instances of placing/building anything that uses the grid
    let blockSize: CGFloat = 40
    
    //set the size of the grid (always 14x14)
    let numRows = 14
    let numCols = 14
    
    //stores the names of the images of the puzzles in the assets
    //let puzzleImageNames: [String] = ["Board0", "Board1", "Board2", "Board3", "Board4", "Board5", "Board6", "Board7"]
    
    var selectedPuzzle: String = "blank"
    
    
    init()
    {
        //call helper methods in separate file to decode JSON files and initialize data
        self.solutions = loadSolutions()
        self.puzzleOutlines = loadPuzzleOutlines()
        let pentominoOutlines = loadPentominoOutlines()
        self.pentominoOutlines = pentominoOutlines
        //pass list of outlines into helper function to get a list of pieces (outline + position)
        self.pieces = piecesInit(pentominoOutlines: pentominoOutlines)
    }
    
    //helper function that makes a list of all pieces with custom intialized positons
    func piecesInit(pentominoOutlines: [PentominoOutline]) -> [Piece]
    {
        //TODO: for now, initial positions are just gonna be the default of (0, 0, .up) until I figure out something better
        //TODO: I will need to make a list of positions based on whatever the initial position is
        var position: Position = Position()
        //TODO: for testing purposes
        position.orientation = .right
        
        var pieces: [Piece] = []
        for pentominoOutline in pentominoOutlines
        {
            pieces.append(Piece(position: position, outline: pentominoOutline))
        }
        return pieces
    }
    
    func puzzleButton(puzzleName: String) -> Void
    {
        //TODO: this?
        self.selectedPuzzle = puzzleName
        print("Puzzle Selected: \(puzzleName)")
    }
    
    //function that returns whether a puzzle is the selected one
    func isSelectedPuzzle(puzzleName: String) -> Bool
    {
        return self.selectedPuzzle == puzzleName
    }
    
    func resetButton() -> Void
    {
        //TODO: this
        //self.selectedPuzzle = "blank"
        print("Reset")
    }
    
    func solveButton() -> Void
    {
        //TODO: this
        print("Solve")
    }
    
    
}
