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
        Text("\(numLetters) different letters")
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

#Preview {
    ContentView()
}
