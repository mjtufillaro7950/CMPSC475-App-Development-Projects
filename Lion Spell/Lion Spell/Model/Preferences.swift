//
//  Preferences.swift
//  Lion Spell
//
//  Created by Michael Tufillaro on 2/9/26.
//

import Foundation

//TODO: need to make enums for the languages and "difficulties" (number of letters). Need to be String, CaseIterable, and Identifiable. Look at the classroom code for the one with the same name.

enum GameDifficulty: String, CaseIterable, Identifiable
{
    case easy = "Easy: 5 Letters"
    case medium = "Medium: 6 Letters"
    case hard = "Hard: 7 Letters"
    //by default, swift will make the raw value equal to the string's name
    //this sets the id so it is identifiable, equal to its rawValue (the above strings)
    var id: String{rawValue}
    
    //this sets the number of letters based on whatever difficulty is picked
    var numberOfLetters: Int
    {
        switch self
        {
            case .easy: return 5
            case .medium: return 6
            case .hard: return 7
        }
    }
}
//TODO: make a Preferences struct that stores one of each of these and initializes them to a default starting value
