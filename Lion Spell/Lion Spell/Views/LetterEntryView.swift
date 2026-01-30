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
                // makes the required letter yellow instead of cyan
                if manager.lettersForEntry[index] == manager.scramble.requiredLetter
                {
                    LetterButton(letter: manager.lettersForEntry[index], color: .yellow)
                }
                else
                {
                    LetterButton(letter: manager.lettersForEntry[index], color: .cyan)
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
