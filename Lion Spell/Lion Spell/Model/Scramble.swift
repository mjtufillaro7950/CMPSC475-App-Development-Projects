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
    
    //These are passed in from the viewmodel according to the preferences selected by the user
    let numberOfLetters: Int
    let listOfWords: [String]
    
    //computed property that calculates the number of legal words
    var numberOfLegalWords: Int
    {
        return self.legalWords.count
    }
    
    //computed property that gets the length of the longest legal word
    var longestLegalWordLength: Int
    {
        //this finds the longest word in legal words by comparing each words' number of characters (the ?? part means that if the array is empty it just returns an empty string)
        let longestWord = self.legalWords.max(by: { $0.count < $1.count }) ?? ""
        return longestWord.count
    }
    
    //computed property that gets all possible pangrams
    var allPossiblePangrams: Set<String>
    {
        var pangrams: Set<String> = []
        for word in self.legalWords
        {
            //if the word is a pangram, add it to the set
            if Set(word).count == numberOfLetters
            {
                pangrams.insert(word)
            }
        }
        return pangrams
    }
    
    //computed property that calculates the max possible score for all legal words
    var maxPossibleScore: Int
    {
        var sum = 0
        for word in self.legalWords
        {
            sum += self.calculateScore(word: word)
        }
        return sum
    }
    
    //computed property that calculates all legal words that begin with each possible letter
    //this returns a tuple, where the first value is the number of letters, and the second value is an array of tuples containing the starting character and all the words that start with that character and have the current number of letters
    var wordsByNumAndStart: [(Int, [(Character, Set<String>)])]
    {
        var output: [(Int, [(Character, Set<String>)])] = []
        //first loop through each possible word length from 4 to the longest possible one
        for wordLength in 4...self.longestLegalWordLength
        {
            var wordsWithThisNumberOfLetters: [(Character, Set<String>)] = []
            //for each letter, make a set of all words that start with that letter and have the current number of letters
            for startingLetter in self.currentLetters
            {
                let wordsThatStartWithThisLetter = self.listOfWords.filter {$0.count == wordLength && $0.first == startingLetter}
                wordsWithThisNumberOfLetters.append((startingLetter, Set(wordsThatStartWithThisLetter)))
            }
            output.append((wordLength, wordsWithThisNumberOfLetters))
        }
        return output
    }
    
    
    //initializer for the Scramble
    init(numberOfLetters: Int, listOfWords: [String])
    {
        self.numberOfLetters = numberOfLetters
        self.listOfWords = listOfWords
        // call function to generate a list of current letters, passing in the number of letters and the list of all words for the current language
        self.currentLetters = Scramble.generateCurrentLetters(numberOfLetters: numberOfLetters, listOfWords: listOfWords)
        
        //pick the middle letter to be the required one
        self.requiredLetter = self.currentLetters[self.currentLetters.count / 2]
        
        //creates the set of legal words by calling the function with the current letters and required letter as arguments
        self.legalWords = Scramble.generateLegalWords(currentLetters: self.currentLetters, requiredLetter: self.requiredLetter, listOfWords: listOfWords)
    }
    
    static func generateCurrentLetters(numberOfLetters: Int, listOfWords: [String]) -> [Character]
    {
        //filter the list of all words to get a list of words that have the required amount of unique letters in them
        let requiredUniqueLetterList = listOfWords.filter {Set($0).count == numberOfLetters}
        // randomly generate an index in that list and pick the word at that index
        let randomIndex = Int.random(in: 0..<requiredUniqueLetterList.count)
        let randomWord = requiredUniqueLetterList[randomIndex]
        // cast the word into a set to get rid of any duplicate letters, cast it back to an array, then return it
        let currentLetters: [Character] = Array(Set(randomWord))
        return currentLetters
    }
    
    //static function that generates a list of legal words given a character array of letters
    static func generateLegalWords(currentLetters: [Character], requiredLetter: Character, listOfWords: [String]) -> Set<String>
    {
        //filter the list of all words in the current language, only including ones that:
            // are a subset of the current letters (I.E only use those letters)
            // contain the required letter
        let legalWords = listOfWords.filter {Set($0).isSubset(of: Set(currentLetters)) && Set($0).contains(requiredLetter)}
        // cast to a set so that I can later use .contains to check if words are legal
        return Set(legalWords)
    }
    
    // given a word, calculate its score
    func calculateScore(word: String) -> Int
    {
        var sum = 0
        if word.count == 4
        {
            sum += 1
        }
        else
        {
            sum += word.count
        }
        if Set(word).count == self.numberOfLetters
        {
            sum += 10
        }
        return sum
    }
}
