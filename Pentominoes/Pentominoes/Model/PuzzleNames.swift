//
//  PuzzleNames.swift
//  Pentominoes
//
//  Created by Michael Tufillaro on 2/26/26.
//

import Foundation

//enum that handles the different puzzle names
enum PuzzleNames: String, CaseIterable
{
    case board0 = "blank"
    case board1 = "6x10"
    case board2 = "5x12"
    case board3 = "OneHole"
    case board4 = "FourNotches"
    case board5 = "FourHoles"
    case board6 = "13Holes"
    case board7 = "Flower"
    
    //also includes a way to access the name of the image corresponding with it
    var imageName: String
    {
        switch self
        {
            case .board0: return "Board0"
            case .board1: return "Board1"
            case .board2: return "Board2"
            case .board3: return "Board3"
            case .board4: return "Board4"
            case .board5: return "Board5"
            case .board6: return "Board6"
            case .board7: return "Board7"
        }
    }
}
