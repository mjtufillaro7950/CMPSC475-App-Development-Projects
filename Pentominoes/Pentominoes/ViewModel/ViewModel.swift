//
//  ViewModel.swift
//  Pentominoes
//
//  Created by LiasPub on 2/24/26.
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
    
    
    init()
    {
        //call helper methods in separate file to decode JSON files and initialize data
        self.pentominoOutlines = loadPentominoOutlines()
        self.puzzleOutlines = loadPuzzleOutlines()
        self.solutions = loadSolutions()
        //TODO: how to intialize pieces? loop thru pentominoOutlines, for each one, initialize its location to be... idk whereever its starting position is supposed to be
    }
    
    
    
}
