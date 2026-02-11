//
//  ViewModel.swift
//  Lion Spell
//
//  Created by Michael Tufillaro on 1/27/26.
//

import Foundation


//create the model, with the observable wrapper so it can read the views
@Observable
class ViewModel
{
    //TODO: these need to be replaced with an Enum and then put into a preferences file? Then pass that into the scramble

    var score: Int = 0
    var currentWord: String = ""
    var wordsFound: [String] = []
    //creates an instance of a new Scramble object
    var scramble: Scramble
    // this stores a mutable copy of the letters that go into the letter entry boxes
    var lettersForEntry: [Character]
    var preferences: Preferences
    {
        //whenever one of the preferences is changed, start a new game
        didSet
        {
            restartButton()
        }
    }
    
    init()
    {
        //creates an instance of the Preferances struct with its default values of 5 letters and English
        let preferences = Preferences()
        self.preferences = preferences
        //passes the number of letters and list of words from the preferences into the Scramble model
        let scramble = Scramble(numberOfLetters: preferences.difficulty.numberOfLetters, listOfWords: preferences.language.listOfWords)
        self.scramble = scramble
        self.lettersForEntry = scramble.currentLetters
    }

    
    //deletes the last letter in the current word
    func deleteButton()
    {
        self.currentWord.removeLast()
    }
    
    // adds a valid word to the list of found words and updates the score
    func enterButton() -> Void
    {
        let currentWord = self.currentWord
        //add the current word to the list of found words
        self.wordsFound.append(currentWord)
        //calculate the score for the current word and update it
        let currentWordScore = calculateScore(word: currentWord)
        self.score += currentWordScore
        //after the word is entered, clear the current word
        self.currentWord = ""
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
        if Set(word).count == preferences.difficulty.numberOfLetters
        {
            sum += 10
        }
        return sum
    }

    
    func shuffleButton() -> Void
    {
        //assigns the proper indices depending on the set difficulty
        var nonMiddleIndices: [Int]
        {
            switch preferences.difficulty
            {
                case .easy: return [0,1,3,4]
                case .medium: return [0,1,2,4,5]
                case .hard: return [0,1,2,4,5,6]
            }
        }
        
        //create a separate array that consists of those indices randomly shuffled
        let shuffled: [Int] = nonMiddleIndices.shuffled()
        
        //loop through the indices, and for each letter, assign it to its new place
        for index in 0..<shuffled.count
        {
            let originalLetterIndex: Int = nonMiddleIndices[index]
            let newLetterIndex: Int = shuffled[index]
            //for each non-center letter in the original array, puts it in a new location in the shuffled array
            self.lettersForEntry[newLetterIndex] = self.scramble.currentLetters[originalLetterIndex]
        }
    }

    func restartButton() -> Void
    {
        //resets all variables
        self.score = 0
        self.currentWord = ""
        self.wordsFound = []
        //creates a new scramble object which makes a new game, using the last used preferences
        self.scramble = Scramble(numberOfLetters: preferences.difficulty.numberOfLetters, listOfWords: preferences.language.listOfWords)
        self.lettersForEntry = scramble.currentLetters
    }
    
    //the disable button needs to be disabled whenever the current word is empty
    func isDeleteDisabled() -> Bool
    {
        return self.currentWord.isEmpty
    }
    
    //returns true if the word passed in is the set of legal words
    func isLegal(word: String) -> Bool
    {
        return self.scramble.legalWords.contains(word)
    }
    
    //returns true if the inputted word has already been guessed
    func alreadyGuessed(word: String) -> Bool
    {
        return self.wordsFound.contains(word)
    }
    
    //the enable button is disabled if the word is illegal or has already been guessed
    func isEnterDisabled() -> Bool
    {
        let currentWord = self.currentWord
        return !isLegal(word: currentWord) || alreadyGuessed(word: currentWord)

    }
    
    func updateFeedback() -> String
    {
        let currentWord = self.currentWord
        //depending on the current state of the current word, update the feedback to the user
        if currentWord.isEmpty
        {
            return "Tap letters below to build a word!"
        }
        if !isLegal(word: currentWord)
        {
            return "Invalid word."
        }
        else if alreadyGuessed(word: currentWord)
        {
            return "You've already guessed that word!"
        }
        else
        {
            return "Valid word!"
        }
    }
    
    //TODO: make a list of functions that calculate the hint stuff: Total possible points, list of all legal words, list of all pangrams, and then list of all words that start with each letter for each length of word from 4 -> longest word
    //TODO: check to see if this even works tbh
    func totalPossiblePoints() -> Int
    {
        var sum = 0
        //first get a list of all legal words for the current language
        for word in self.scramble.legalWords
        {
            //for each one, call the calculate score function and add them up
            sum += calculateScore(word: word)
        }
        return sum
    }
    //TODO: the latter shouldn't be too too bad, I just need a 3D array- outermost is one per possible word length, middle is one per every possible starting letter, innermost is a list of all words that start with that specific letter and have that many letters
}
