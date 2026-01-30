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
    //TODO: FIRST THINGS FIRST- tie all the views to their proper values so I can check stuff in real time
    // this will be an "instance" of the game. I need to be able to access the model somehow
    // make an instance of the Scramble called currentGame, then access it.
    //what variables related to the game would need to be tracked?
    var score: Int = 0
    var currentWord: String = ""
    var wordsFound: [String] = []
    var wordEntryFeedback: String = "Tap letters below to build a word!"
    //creates an instance of a new Scramble object
    var scramble: Scramble
    // this stores a mutable copy of the letters that go into the letter entry boxes
    var lettersForEntry: [Character]
    
    init()
    {
        let scramble = Scramble()
        self.scramble = scramble
        self.lettersForEntry = scramble.currentLetters
    }
    
    //idk if I need this or not
//    func startNewGame()
//    {
//        //resets all variables
//        self.score = 0
//        self.currentWord = ""
//        self.wordsFound = []
//        self.wordEntryFeedback = "Tap letters below to build a word!"
//        //creates a new scramble object which makes a new game
//        self.scramble = Scramble()
//        self.lettersForEntry = scramble.currentLetters
//    }
    
    //These functions handle the different buttons
    func deleteButton()
    {
        //deletes the last letter in the current word
        if self.currentWord.count > 0
        {
            self.currentWord.removeLast()
        }
        //if the current word is blank, reset the feedback to the default
        if self.currentWord.count == 0
        {
            self.wordEntryFeedback = "Tap letters below to build a word!"
        }
    }
    
    func enterButton() -> Void
    {
        //TODO: if the word is not in the legal word list OR if the word has already been entered, send feedback to the user. If it's good, then add it to the found words, give positive feedback, & update score
        print("Enter pressed!")
    }

    func shuffleButton() -> Void
    {
        //create an array of the indices that need to be shuffled (all except middle)
        let fiveIndices: [Int] = [0,1,3,4]
        //let sixIndices: [Int] = [0,1,2,4,5]
        //let sevenIndices: [Int] = [0,1,2,4,5,6]
        
        //TODO: set this equal to one of these above arrays corresponding to the number of allowed letters
        let nonMiddleIndices = fiveIndices
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
        self.wordEntryFeedback = "Tap letters below to build a word!"
        //creates a new scramble object which makes a new game
        self.scramble = Scramble()
        self.lettersForEntry = scramble.currentLetters
    }
    
    func isLegal(word: String) -> Bool
    {
        //returns true if the word passed in is the set of legal words
        return self.scramble.legalWords.contains(word)
    }
    
    //whether the current word at any point is valid, which needs to be updated as soon as a new letter is entered or removed

    //As far as I can tell, I do not need an init rn because I can initialize these variables to their proper starting values
    //all the viewmodel variables are initialized to their correct values, and the views should read those and update in real time
    //can access the Scramble variables with scramble.whatever
    //what functions do I need right now? Buttons
        //Delete, Enter, Shuffle, Restart
    
    //Delete button removes the last letter in currentWord (String(self.currentWord.dropLast())
    
    //Enter button checks the current word against the words found and list of valid words. If its valid and hasn't been found, add it to the list and update score. If its bad, update the feedback to tell them
        //OR, constantly check and update feedback whenever a letter is entered, only letting the user enter when its valid
    
    //Shuffle button... TBD
    
    //Restart button basically just sets all the variables back to their original starting values, in the process creating a new Scramble() object
    
    //updateScore function will read the current word, and determine its point values
        // 1 point for 4 letter word
        // if longer than 4 letters, points equal to length
        // if it uses all 5 letters, extra 10 points

}
