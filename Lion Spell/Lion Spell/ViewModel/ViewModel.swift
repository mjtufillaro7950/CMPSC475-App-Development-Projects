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
    // this will be an "instance" of the game. I need to be able to access the model somehow
    // make an instance of the Scramble called currentGame, then access it.
    //what variables related to the game would need to be tracked?
    //current score, current word being spelled, total words found
    var score: Int = 0
    var currentWord: String = ""
    var wordsFound: [String] = []
    //creates an instance of a new Scramble object
    var scramble: Scramble = Scramble()
    
    //whether the current word at any point is valid, which needs to be updated as soon as a new letter is entered or removed
    init()
    {
        //what needs to be done upon starting a game?
        //all the viewmodel variables are initialized to their correct values, and the views should read those and update in real time
        //can access the Scramble variables with scramble.whatever
        
    }
}
