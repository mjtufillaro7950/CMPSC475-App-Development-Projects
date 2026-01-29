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
    //TODO: CHANGE LATER
    var wordEntryFeedback: String = "DEFAULT WORD ENTRY FEEDBACK"
    //creates an instance of a new Scramble object
    var scramble: Scramble = Scramble()
    
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
