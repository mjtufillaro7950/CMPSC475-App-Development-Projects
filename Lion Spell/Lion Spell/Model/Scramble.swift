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
    let legalWords: Set<String>
    
    //initializer for the Scramble
    init()
    {
        //TODO: REMOVE PRINTS LATER
        print("Scramble is running:")
        
        // call function to generate a list of current letters
        self.currentLetters = Scramble.generateCurrentLetters()
        print("Current Letters: \(self.currentLetters)")
        
        //pick the middle letter to be the required one
        self.requiredLetter = self.currentLetters[self.currentLetters.count / 2]
        print("Required Letter: \(self.requiredLetter)")
        
        //creates the set of legal words by calling the function with the current letters and required letter as arguments
        self.legalWords = Scramble.generateLegalWords(currentLetters: self.currentLetters, requiredLetter: self.requiredLetter)
        let firstTwentyWords = self.legalWords.prefix(20)
        print("First 20 Legal Words: \(Array(firstTwentyWords))")
    }
    
    //how to get current letters/required letter?
        // get a list of all words with exactly 5 unique letters (.filter?)
        // randomly pick one of these words, make those letters the current letters, then randomly pick the required one
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
    
    func isLegal(word: String) -> Bool
    {
        return true
    }
    // tentative function list
        // isLegal(word)
            // once a legal list is made, this can be used to check if a guess is accurate
        //shuffle()?
            //idk if it would go into the model or the view
    
    
}
