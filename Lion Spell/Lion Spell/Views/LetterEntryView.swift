//
//  LetterEntryView.swift
//  Lion Spell
//
//  Created by Michael Tufillaro on 1/25/26.
//

import Foundation
import SwiftUI

struct LetterEntryView: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    
    //assigns the number of letters used
    @Binding var numLetters: Int
    var body: some View
    {
        HStack
        {
            ForEach(0...numLetters-1, id: \.self)
            {
                index in
                //this checks to see if the index is the middle one, and if so, makes the middle box yellow
                //TODO: make this work with shuffle
                if index+1 == Int(ceil(Double(numLetters)/2))
                {
                    LetterButton(letter: manager.scramble.currentLetters[index], color: .yellow)
                }
                else
                {
                    LetterButton(letter: manager.scramble.currentLetters[index], color: .cyan)
                }
            }
        }
    }
}


struct LetterButton: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    let letter: Character
    let color: Color
    var body: some View
    {
        Button
        {
            //adds the current letter into the current word string
            if manager.currentWord.count < 18
            {
                manager.currentWord += String(letter)
            }
            else
            {
                manager.wordEntryFeedback = "Too Many Characters!"
            }
        }
        label:
        {
            ZStack
            {
                RoundedRectangle(cornerRadius: 16)
                    .frame(width: 50, height: 70)
                    .foregroundColor(color)
                Text(String(letter))
                    .foregroundColor(.black)
                    .font(.largeTitle)
                    .bold()
                    .textCase(.uppercase)
            }
        }
    }
}

#Preview {
    MainView()
        .environment(ViewModel())
}
