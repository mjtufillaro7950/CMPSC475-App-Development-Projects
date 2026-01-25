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
    //need the current available letters, the required one, and a list of legal words
    //the user must use the letters, the required one at least once, to form a word on the legal words list
    //how to get current letters/required letter?
        // get a list of all words with exactly 5 unique letters (.filter?)
        // randomly pick one of these words, make those letters the current letters, then randomly pick the required one
    // from there, need to build a list of legal words that work with the current/required letters
        // for each word, check to see if its letters are a subset of the user's available letters (including the required one)
        // if it is, add it to legal words list
    // tentative function list
        // generateCurrentLetters()
        // generateRequiredLetter(currentLetters)
        // generateLegalWords(currentLetters, requiredLetter)
        // isLegal(word)
            // once a legal list is made, this can be used to check if a guess is accurate
    
    
}
