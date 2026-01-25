//
//  ContentView.swift
//  Lion Spell
//
//  Created by LiasPub on 1/24/26.
//

import SwiftUI
import Foundation

struct MainView: View
{
    //assigns the number of letters given as a State var so it can be passed into other views
    @State var numLetters = 5
    var body: some View
    {
        VStack
        {
            HStack
            {
                Text("LION SPELL")
                    .font(.largeTitle)
                    .bold()
                Spacer()
                ScoreView()
            }
            CurrentWordView()
            Text("Scrollable list of found words")
            ZStack
            {
                RoundedRectangle(cornerRadius: 16)
                    .frame(height: 50)
                    .foregroundColor(.cyan)
                ScrollView(.horizontal)
                {
                    HStack
                    {
                        ForEach(1...20, id: \.self)
                        {index in
                            Text("Word \(index)")
                        }
                    }
                }
                .padding()
            }
            //calls the Letter Entry view in another file, passing in the set number of letters in this file
            LetterEntryView(numLetters: $numLetters)
            
            HStack
            {
                RegButton(text: "Delete", color: .red)
                
                RegButton(text: "Enter", color: .green)
            }
            Spacer()
            HStack
            {
                RegButton(text: "Shuffle", color: .green)
                Spacer()
                RegButton(text: "Restart", color: .red)
            }
        }
        .padding()
        .background(Color.blue)
    }
}


//I might be able to make both button types have one parent
struct RegButton: View
{
    let text: String
    let color: Color
    var body: some View
    {
        Button
        {
            //this needs to be able to be replaced with a custom action
            print("Button Pressed!")
        }
        label:
        {
            ZStack
            {
                RoundedRectangle(cornerRadius: 16)
                    .frame(width: 70, height: 50)
                    .foregroundColor(color)
                Text(text)
                    .foregroundColor(.black)
            }
        }
    }
}


//view that handles the scoreboard in the top right
struct ScoreView: View
{
    var body: some View
    {
        VStack
        {
            Text("Score")
                .font(.footnote)
            ZStack
            {
                RoundedRectangle(cornerRadius: 16)
                    .frame(width: 70, height: 50)
                    .foregroundColor(.cyan)
                Text("0")
                    .font(.title)
            }
            
        }
    }
}



#Preview
{
    MainView()
}
