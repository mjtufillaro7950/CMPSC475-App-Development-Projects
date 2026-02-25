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
    var puzzleOutlines: [PuzzleOutline] = []
    var pentominoOutlines: [PentominoOutline] = []
    //The solutions in the provided JSON file are formatted as dictionaries mapping a puzzle name to its solutions, which are a dict mapping a piece name to its correct position
    var solutions: [String: [String: Position]] = [:]
    
    
    init()
    {
        //call helper methods to decode JSON files and initialize data
        self.pentominoOutlines = loadPentominoOutlines()
        self.puzzleOutlines = loadPuzzleOutlines()
        self.solutions = loadSolutions()
    }
    
    
    //in order to do JSON decoding like in LionSpell, the data types need to be codable. Therefore, make codable versions of all necessary ones
    private struct CodablePoint: Codable
    {
        let x: Int
        let y: Int
        enum CodingKeys: String, CodingKey
        {
            case x, y
        }
    }
    
    private struct CodableSize: Codable
    {
        let width: Int
        let height: Int
        enum CodingKeys: String, CodingKey
        {
            case width, height
        }
    }
    
    private struct CodablePentominoOutline: Codable
    {
        let name: String
        let size: CodableSize
        let outline: [CodablePoint]
        enum CodingKeys: String, CodingKey
        {
            case name, size, outline
        }
    }
    
    private struct CodablePuzzleOutline: Codable
    {
        let name: String
        let size: CodableSize
        let outlines: [[CodablePoint]]
        enum CodingKeys: String, CodingKey
        {
            case name, size, outlines
        }
    }
    
    private struct CodablePosition: Codable
    {
        let x: Int
        let y: Int
        //here orientation is a string because in the JSON file that is how they are represented
        let orientation: String
        enum CodingKeys: String, CodingKey
        {
            case x, y, orientation
        }
    }
    
    
    //load the outline data and return a list of pentomino outlines
    private func loadPentominoOutlines() -> [PentominoOutline]
    {
        //do what was done in LionSpell, load data from JSON files and format it into the proper arrays
        guard
            let url = Bundle.main.url(forResource: "PentominoOutlines", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let decoded = try? JSONDecoder().decode([CodablePentominoOutline].self, from: data)
        else {
            //safe fallback so it doesn't crash, shouldnt happen
            print("Somthing went wrong when decoding Pentomino Outlines")
            return []
        }
        //if it decoded properly, for each element in the codable pentomino outline, build a proper PentominoOutline and add it to the list
        var outlines: [PentominoOutline] = []
        for decodedPentOutline in decoded
        {
            var points: [Point] = []
            //this builds a list of regular Points from the list of codable points
            for point in decodedPentOutline.outline
            {
                points.append(Point(x: point.x, y: point.y))
            }
            //fetches the size from the decoded points codablesize
            let size = Size(width: decodedPentOutline.size.width, height: decodedPentOutline.size.height)
            //creates a new PentominoOutline object using the fetched data and appends it to the output list
            let outline = PentominoOutline(name: decodedPentOutline.name, size: size, outline: points)
            outlines.append(outline)
        }
        //after all outlines have been added to the list of outlines, update class variable
        return outlines
    }
    
    
    //do pretty much the same thing for loading the puzzle outlines
    private func loadPuzzleOutlines() -> [PuzzleOutline]
    {
        //do what was done in LionSpell, load data from JSON files and format it into the proper arrays
        guard
            let url = Bundle.main.url(forResource: "PuzzleOutlines", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let decoded = try? JSONDecoder().decode([CodablePuzzleOutline].self, from: data)
        else {
            //safe fallback so it doesn't crash, shouldn't happen
            print("Somthing went wrong when decoding Puzzle Outlines")
            return []
        }
        //if it decoded properly, for each element in the codable puzzle outline, build a proper PuzzleOutline and add it to the list
        var outputOutlines: [PuzzleOutline] = []
        for decodedPuzzOutline in decoded
        {
            //make this a double nested array of points instead of single nested
            var outlines: [[Point]] = []
            //loop through each outline in the decoded puzzle outline
            for outline in decodedPuzzOutline.outlines
            {
                //for each outline, add the list of points to an inner array
                var points: [Point] = []
                for point in outline
                {
                    points.append(Point(x: point.x, y: point.y))
                }
                //append the inner array to the outer array
                outlines.append(points)
            }
            //fetches the size from the decoded points codablesize
            let size = Size(width: decodedPuzzOutline.size.width, height: decodedPuzzOutline.size.height)
            //creates a new PuzzleOutline object using the fetched data and appends it to the output list
            let tempOutline = PuzzleOutline(name: decodedPuzzOutline.name, size: size, outlines: outlines)
            outputOutlines.append(tempOutline)
        }
        //after all outlines have been added to the list of outlines, update class variable
        return outputOutlines
    }
    
    //similar process again here
    private func loadSolutions() -> [String: [String: Position]]
    {
        //do what was done in LionSpell, load data from JSON files and format it into the proper arrays
        guard
            let url = Bundle.main.url(forResource: "Solutions", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            //the data type here needs to match the data type of the solutions in the JSON
            let decoded = try? JSONDecoder().decode([String: [String: CodablePosition]].self, from: data)
        else {
            //safe fallback so it doesn't crash, shouldn't happen
            print("Somthing went wrong when decoding Solutions")
            return [:]
        }
        
        var outputSolutions: [String: [String: Position]] = [:]
        
        //loop through each puzzle
        for (puzzleName, solutionDict) in decoded
        {
            //need to convert from CodablePosition dict to regular Position dict
            var convertedSolution: [String: Position] = [:]
            //loop through each piece in the solution
            for (pieceName, codablePosition) in solutionDict
            {
                //convert the string representation of the orientation into an orientation with rawValue
                //needs the default case of .up here for some reason
                let orientation = Orientation(rawValue: codablePosition.orientation) ?? .up
                //build the proper position
                let position = Position(x: codablePosition.x, y: codablePosition.y, orientation: orientation)
                //add the new pieceName: position pair to the inner dict
                convertedSolution[pieceName] = position
            }
            //add the puzzle name: solution pair to the outer dict
            outputSolutions[puzzleName] = convertedSolution
        }
        //update class variable with output
        return outputSolutions
    }
}
