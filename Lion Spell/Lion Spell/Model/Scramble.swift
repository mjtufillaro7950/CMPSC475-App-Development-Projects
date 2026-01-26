//
//  Model.swift
//  Lion Spell
//
//  Created by Michael Tufillaro on 1/25/26.
//

import Foundation
//use Words.allWords.englishWords to access the list of all words
//use .filter to get 5 starting letters

struct Scramble
{
    // the current letters should be an array of characters
    let currentLetters: [Character]
    // the required letter is just one character
    let requiredLetter: Character
    // the legal words are a list of Strings
    let legalWords: [String]
    //the number of letters the user has to work with
    let numberOfLetters: Int
    
    //initializer for the Scramble
    init()
    {
        //TODO: REMOVE PRINTS LATER
        print("Scramble is running:")
        self.numberOfLetters = 5
        self.currentLetters = Scramble.generateCurrentLetters()
        print("Current Letters: \(self.currentLetters)")
        //TEMP RETURN VALUES
        //pick the middle letter to be the required one
        self.requiredLetter = self.currentLetters[self.currentLetters.count / 2]
        print("Required Letter: \(self.requiredLetter)")
        self.legalWords = []
    }
    
    //how to get current letters/required letter?
        // get a list of all words with exactly 5 unique letters (.filter?)
        // randomly pick one of these words, make those letters the current letters, then randomly pick the required one
    static func generateCurrentLetters() -> [Character]
    {
        //filter the list of all english words to get a list of words that have exactly 5 unique letters in them
        let fiveUniqueLetterList = Words.allWords.englishWords.filter {Set($0).count == 5}
        // randomly generate an index in that list and pick the word at that index
        let randomIndex = Int.random(in: 0..<fiveUniqueLetterList.count)
        let randomWord = fiveUniqueLetterList[randomIndex]
        // cast the word into a set to get rid of any duplicate letters, cast it back to an array, then return it
        let currentLetters: [Character] = Array(Set(randomWord))
        return currentLetters
    }
    //the user must use the letters, the required one at least once, to form a word on the legal words list
    
    // from there, need to build a list of legal words that work with the current/required letters
        // for each word, check to see if its letters are a subset of the user's available letters (including the required one)
        // if it is, add it to legal words list
    // tentative function list
        // generateCurrentLetters()
        // generateRequiredLetter(currentLetters)
        // generateLegalWords(currentLetters, requiredLetter)
        // isLegal(word)
            // once a legal list is made, this can be used to check if a guess is accurate
        //shuffle()?
            //idk if it would go into the model or the view
    
    
}
