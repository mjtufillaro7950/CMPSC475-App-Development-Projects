//
//  FoundWordsView.swift
//  Lion Spell
//
//  Created by Michael Tufillaro on 1/25/26.
//

import SwiftUI

struct FoundWordsView: View
{
    var body: some View
    {
        ZStack
        {
            RoundedRectangle(cornerRadius: 16)
                .frame(height: 100)
                .foregroundColor(.cyan)
            VStack
            {
                Text("Found Words:")
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .font(.headline)
                    .bold()
                Spacer()
                scrollingWords()
            }
            .padding()
            .frame(height: 100)
        }
    }
}

struct scrollingWords: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    
    var body: some View
    {
        ScrollView(.horizontal)
        {
            HStack
            {
                //loop through each word that has been found (in reverse order)
                ForEach(manager.wordsFound.reversed(), id: \.self)
                {
                    word in
                    constructFoundWord(word: word, score: manager.scramble.calculateScore(word: word))
                    
                }
            }
        }
    }
}
struct constructFoundWord: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    
    let word: String
    let score: Int
    //choose the color of the word and its box depending on if its a pangram or not
    var colors: (Color, Color)
    {
        //if the word is a pangram, make it yellow and black instead of black and yellow
        if manager.scramble.isPangram(word: word)
        {
            (.yellow, .black)
        }
        else
        {
            (.black, .yellow)
        }
    }
    
    var body: some View
    {
        ZStack
        {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(colors.0)
            Text("\(word): +\(score)")
                .bold()
                .textCase(.uppercase)
                .foregroundColor(colors.1)
                .padding(.horizontal, 10)
        }
    }
}

#Preview
{
    MainView()
        .environment(ViewModel())
    
}
