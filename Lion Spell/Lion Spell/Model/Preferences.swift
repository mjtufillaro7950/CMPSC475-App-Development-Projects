//
//  Preferences.swift
//  Lion Spell
//
//  Created by Michael Tufillaro on 2/9/26.
//

import Foundation

//enum for the difficulty
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

//enum for the language choices
enum LanguageSelection: String, CaseIterable, Identifiable
{
    case english = "English"
    case french = "French"
    case german = "German"
    case italian = "Italian"
    
    //this sets the id so it is identifiable, equal to its rawValue (the above strings)
    var id: String{rawValue}
    
    //creates a variable that accesses the proper list of words depending on what language is selected
    var listOfWords: [String]
    {
        switch self
        {
            case .english: return Words.allWords.englishWords
            case .french: return Words.allWords.frenchWords
            case .german: return Words.allWords.germanWords
            case .italian: return Words.allWords.italianWords
        }
    }
    
}

//make a Preferences struct that stores one of each of the preferences and initializes them to a default starting value of easy (5 letters) and english
struct Preferences
{
    var difficulty: GameDifficulty = .easy
    var language: LanguageSelection = .english
}
