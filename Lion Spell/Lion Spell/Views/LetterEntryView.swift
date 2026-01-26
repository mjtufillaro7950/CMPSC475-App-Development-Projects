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
    //assigns the number of letters used
    @Binding var numLetters: Int
    var body: some View
    {
        HStack
        {
            ForEach(1...numLetters, id: \.self)
            {
                index in
                //this checks to see if the index is the middle one, and if so, makes the middle box yellow
                //TODO: replace this so that it correctly adds the proper letters
                if index == Int(ceil(Double(numLetters)/2))
                {
                    LetterButton(text: "A", color: .yellow)
                }
                else
                {
                    LetterButton(text: "A", color: .cyan)
                }
            }
        }
    }
}


struct LetterButton: View
{
    let text: Character
    let color: Color
    var body: some View
    {
        Button
        {
            letterEntryPressed()
        }
        label:
        {
            ZStack
            {
                RoundedRectangle(cornerRadius: 16)
                    .frame(width: 50, height: 70)
                    .foregroundColor(color)
                Text(String(text))
                    .foregroundColor(.black)
                    .font(.largeTitle)
                    .bold()
            }
        }
    }
}

func letterEntryPressed() -> Void
{
    //TODO: Make this add the current letter into the currently built word string
    print("Letter Button Pressed!")
}

#Preview {
    MainView()
}
