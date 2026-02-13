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
                    .foregroundColor(.black)
                Spacer()
                ScoreView()
            }
            
            FoundWordsView()
            CurrentWordView()
            Spacer()
            LetterEntryView()
            Spacer()
            ButtonsView(showSettings: $showSettings)
        }
        .padding()
        .background(DesignConstants.mainColor)
        //this displays the settings sheet if the button is toggled
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
                .foregroundColor(.black)
            ZStack
            {
                RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                    .frame(width: 70, height: 50)
                    .foregroundColor(DesignConstants.lighterColor)
                // the score checks the viewmodel and updates when the score updates
                Text(String(manager.score))
                    .font(.title)
                    .foregroundColor(.black)
            }
            
        }
    }
}



#Preview
{
    MainView()
        .environment(ViewModel())
}
