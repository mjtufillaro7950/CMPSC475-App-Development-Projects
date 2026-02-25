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
        let position: Position = Position()
        
        var pieces: [Piece] = []
        for pentominoOutline in pentominoOutlines
        {
            pieces.append(Piece(position: position, outline: pentominoOutline))
        }
        return pieces
    }
    
}
