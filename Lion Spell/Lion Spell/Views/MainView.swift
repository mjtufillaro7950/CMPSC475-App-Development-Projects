//
//  ContentView.swift
//  Lion Spell
//
//  Created by Michael Tufillaro on 1/24/26.
//

import SwiftUI
import Foundation

//THIS IS THE MAIN VIEW
struct MainView: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    //this state variable keeps track of whether or not the settings are being shown
    @State var showSettings: Bool = false
    
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
            LetterEntryView()
            ButtonsView(showSettings: $showSettings)
        }
        .padding()
        .background(Color.blue)
        .sheet(isPresented: $showSettings)
        {
            SettingsSheetView()
        }
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
                .bold()
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
