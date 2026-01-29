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
    
    //whether the current word at any point is valid, which needs to be updated as soon as a new letter is entered or removed
    init()
    {
        //TODO: newgame() or something like that, make a new Scramble, reset everything to blank, add the new letters
        //backSpace
        //Reset
        //enter
        
    }
}
