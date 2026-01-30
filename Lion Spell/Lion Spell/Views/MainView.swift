//
//  ContentView.swift
//  Lion Spell
//
//  Created by Michael Tufillaro on 1/24/26.
//

import SwiftUI
import Foundation

struct MainView: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    
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
            
            FoundWordsView()
                .padding(.bottom, 20)
            CurrentWordView()
                .padding(.bottom, 20)
            
            //calls the Letter Entry view in another file, passing in the set number of letters in this file
            LetterEntryView(numLetters: $numLetters)
            //this can def be simplified
            ButtonsView()
        }
        .padding()
        .background(Color.blue)
    }
}



//view that handles the scoreboard in the top right
struct ScoreView: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
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
                // the score checks the viewmodel and updates when the score there updates
                Text(String(manager.score))
                    .font(.title)
            }
            
        }
    }
}



#Preview
{
    MainView()
        .environment(ViewModel())
}
