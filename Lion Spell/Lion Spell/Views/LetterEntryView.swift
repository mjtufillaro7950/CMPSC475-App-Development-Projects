//
//  LetterEntryView.swift
//  Lion Spell
//
//  Created by LiasPub on 1/25/26.
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
    let text: String
    let color: Color
    var body: some View
    {
        Button
        {
            //this needs to be able to be replaced with a custom action
            print("Letter Button Pressed!")
        }
        label:
        {
            ZStack
            {
                RoundedRectangle(cornerRadius: 16)
                    .frame(width: 50, height: 70)
                    .foregroundColor(color)
                Text(text)
                    .foregroundColor(.black)
                    .font(.largeTitle)
                    .bold()
            }
        }
    }
}


#Preview {
    MainView()
}
