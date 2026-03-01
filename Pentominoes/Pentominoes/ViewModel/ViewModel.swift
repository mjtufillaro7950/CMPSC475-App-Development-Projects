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
     
    //initialize the starting selected puzzle to the blank one
    var selectedPuzzle: String = "blank"
    
    var startingCoordinates: [(Int, Int)] = []    
    
    //variables that store stuff for tap and drag functionality
    var draggedPieceIndex: Int = -1
    
    init()
    {
        //call helper methods in separate file to decode JSON files and initialize data
        self.solutions = loadSolutions()
        self.puzzleOutlines = loadPuzzleOutlines()
        let pentominoOutlines = loadPentominoOutlines()
        self.pentominoOutlines = pentominoOutlines
        self.startingCoordinates = getStartingCoordinates()
        //pass list of outlines into helper function to get a list of pieces (outline + position)
        self.pieces = piecesInit(pentominoOutlines: pentominoOutlines)
    }
    
    //helper function that makes a list of all pieces with custom intialized positons
    func piecesInit(pentominoOutlines: [PentominoOutline]) -> [Piece]
    {
        var pieces: [Piece] = []
        //loop through every piece
        for index in 0..<pentominoOutlines.count
        {
            //get the outline and the starting position for each piece
            let pentominoOutline = pentominoOutlines[index]
            let startingPosition = Position(x: startingCoordinates[index].0, y: startingCoordinates[index].1, orientation: .up)
            pieces.append(Piece(position: startingPosition, outline: pentominoOutline))
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
        for index in 0..<pieces.count
        {
            let currentStartingCoordinates = startingCoordinates[index]
            //for each piece, update its Position to its starting one
            let startingPosition = Position(x: currentStartingCoordinates.0, y: currentStartingCoordinates.1, orientation: .up)
            pieces[index].position = startingPosition
        }
    }
    
    func solveButton() -> Void
    {
        for index in 0..<pieces.count
        {
            //for each piece, update its Position to its proper one for the current puzzle
            let solutionPosition = self.getSolutionPosition(piece: pieces[index])
            pieces[index].position = solutionPosition
        }
    }
    
    
    //function that checks if a piece is in its solution position
    func isInSolutionPosition(piece: Piece) -> Bool
    {
        //if the selected puzzle is the blank one, there is no solution so always return false
        if self.selectedPuzzle == "blank"
        {
            return false
        }
        let solutionPosition = self.getSolutionPosition(piece: piece)
        let sameX = (piece.position.x == solutionPosition.x)
        let sameY = (piece.position.y == solutionPosition.y)
        let sameOrientation = (piece.position.orientation == solutionPosition.orientation)
        return sameX && sameY && sameOrientation
    }
    
    func getStartingCoordinates() -> [(Int, Int)]
    {
//        let startingCoordinates: [(Int, Int)] =
//            [
//                (0,15),
//                (4,15),
//                (8,15),
//                (12,15),
//                (0,21),
//                (4,21),
//                (8,21),
//                (12,21),
//                (0,27),
//                (4,27),
//                (8,27),
//                (12,27)
//            ]
        
        var startingCoordinates: [(Int, Int)] = []
        for y in stride(from: 15, through: 27, by: 6)
        {
            for x in stride(from: 0, through: 12, by: 4)
            {
                startingCoordinates.append((x,y))
            }
        }
        return startingCoordinates
    }
    
    //function that gets the outline with a given name, defaulting to the first if one is not given
    func getPuzzleOutlineFromName(puzzleName: String) -> PuzzleOutline
    {
        for outline in self.puzzleOutlines
        {
            if outline.name == puzzleName
            {
                return outline
            }
        }
        return self.puzzleOutlines[0]
    }
    
    //function that gets the index of a piece in the array of Pieces, returning -1 if it does not exist
    func getPieceIndex(piece: Piece) -> Int
    {
        let targetName = piece.outline.name
        for index in 0..<self.pieces.count
        {
            if self.pieces[index].outline.name == targetName
            {
                return index
            }
        }
        return -1
    }

    
    //when a drag is started, set the proper values
    func startDrag(piece: Piece)
    {
        //set the index of the currently dragged piece in the piece array
        self.draggedPieceIndex = getPieceIndex(piece: piece)
    }
    
    func endDrag(at location: CGPoint)
    {
        //calculate the proper unit square of the final position
        let newX = Int(location.x / self.blockSize)
        let newY = Int(location.y / self.blockSize)
        
        //update the piece's position in the array
        if self.draggedPieceIndex != -1
        {
            self.pieces[self.draggedPieceIndex].position.x = newX
            self.pieces[self.draggedPieceIndex].position.y = newY
        }
        else
        {
            print("Error: draggedPieceIndex = -1")
        }
        
        //clear drag state
        self.draggedPieceIndex = -1
    }
    
    //helper functions that adjust the orientation of a piece using extended Position functions
    func rotatePiece(piece: Piece)
    {
        if self.draggedPieceIndex != -1
        {
            //rotate the piece clockwise- up goes to right, right goes to down, etc
            self.pieces[self.draggedPieceIndex].position.rotateClockwise()
        }
        else
        {
            print("Error: draggedPieceIndex = -1")
        }
    }
    
    func flipPiece(piece: Piece)
    {
        if self.draggedPieceIndex != -1
        {
            //flip the piece's orientation- up goes to upMirrored, right goes to rightMirrored, etc
            self.pieces[self.draggedPieceIndex].position.flip()
        }
        else
        {
            print("Error: draggedPieceIndex = -1")
        }
    }
    
    func getSolutionPosition(piece: Piece) -> Position
    {
        let puzzleSolution = self.solutions[self.selectedPuzzle]
        //the ! mean that it aborts execution if its nil (it won't be)
        return puzzleSolution![piece.outline.name]!
    }
}
