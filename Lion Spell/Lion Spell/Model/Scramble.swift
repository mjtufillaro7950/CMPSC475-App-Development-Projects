//
//  Model.swift
//  Lion Spell
//
//  Created by Michael Tufillaro on 1/25/26.
//

import Foundation

struct Scramble
{
    // the current letters should be an array of characters
    let currentLetters: [Character]
    // the required letter is just one character
    let requiredLetter: Character
    // the legal words are a list of Strings
    let legalWords: Set<String>
    
    //TODO: these need to be replaced with a way to take in values- a switch case based on the values in preferences?
    let numberOfLetters: Int
    let wordsForCurrentLanguage: [String]
    
    //initializer for the Scramble
    init(numberOfLetters: Int, wordsForCurrentLanguage: [String])
    {
        self.numberOfLetters = numberOfLetters
        self.wordsForCurrentLanguage = wordsForCurrentLanguage
        // call function to generate a list of current letters
        self.currentLetters = Scramble.generateCurrentLetters()
        
        //pick the middle letter to be the required one
        self.requiredLetter = self.currentLetters[self.currentLetters.count / 2]
        
        //creates the set of legal words by calling the function with the current letters and required letter as arguments
        self.legalWords = Scramble.generateLegalWords(currentLetters: self.currentLetters, requiredLetter: self.requiredLetter)
    }
    
    static func generateCurrentLetters() -> [Character]
    {
        //filter the list of all english words to get a list of words that have the required amount of unique letters in them
        let fiveUniqueLetterList = Words.allWords.englishWords.filter {Set($0).count == 5}
        // randomly generate an index in that list and pick the word at that index
        let randomIndex = Int.random(in: 0..<fiveUniqueLetterList.count)
        let randomWord = fiveUniqueLetterList[randomIndex]
        // cast the word into a set to get rid of any duplicate letters, cast it back to an array, then return it
        let currentLetters: [Character] = Array(Set(randomWord))
        return currentLetters
    }
    
    //static function that generates a list of legal words given a character array of letters
    static func generateLegalWords(currentLetters: [Character], requiredLetter: Character) -> Set<String>
    {
        //filter the list of all english words, only including ones that:
            // are a subset of the current letters (I.E only use those letters)
            // contain the required letter
        let legalWords = Words.allWords.englishWords.filter {Set($0).isSubset(of: Set(currentLetters)) && Set($0).contains(requiredLetter)}
        // cast to a set so that I can later use .contains to check if words are legal
        return Set(legalWords)
    }
}
