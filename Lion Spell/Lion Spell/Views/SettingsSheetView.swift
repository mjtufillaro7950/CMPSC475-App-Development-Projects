//
//  SettingsSheetView.swift
//  Lion Spell
//
//  Created by Michael Tufillaro on 2/10/26.
//

import SwiftUI

struct SettingsSheetView: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    //state variable that controls if the hints are being shown or not
    @State var showHints = false
    //need to make a state value for the difficulty>
    var body: some View
    {
        //TODO: for right now, just add pickers for difficulty and language. Make sure they toggle a new game when selected and accurately change stuff
        ScrollView(.vertical)
        {
            VStack
            {
                Text("Choose Difficulty:")
                DifficultyPickerView()
                Text("Choose Language:")
                LanguagePickerView()
                //Toggle that triggers the hints to appear
                Toggle("Show Hints:", isOn: $showHints)
                
                if showHints
                {
                    Text("ayyyy the hints be showin yo")
                }
            }
            .padding()
        }
    }
}

struct DifficultyPickerView: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    var body: some View
    {
        //This creates a binding from the difficulty preferences in manager to this struct so an enum can be built from it
        var difficultyBinding: Binding<GameDifficulty> {
            Binding(
                //this determines how you access the binding value
                get:
                    {
                        manager.preferences.difficulty
                    },
                //this determines how you change the binding value
                set:
                    {
                        manager.preferences.difficulty = $0
                    }
            )
        }
        
        Picker("Difficulty", selection: difficultyBinding)
        {
            //makes a picker with a different selection for each possible case
            ForEach(GameDifficulty.allCases)
            {
                difficulty in Text(difficulty.rawValue)
                    .tag(difficulty)
            }
        }
        .pickerStyle(.segmented)
    }
}

struct LanguagePickerView: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    var body: some View
    {
        //This creates a binding from the difficulty preferences in manager to this struct so an enum can be built from it
        var languageBinding: Binding<LanguageSelection> {
            Binding(
                get:
                    {
                        manager.preferences.language
                    },
                set:
                    {
                        manager.preferences.language = $0
                    }
            )
        }
        
        Picker("Language", selection: languageBinding)
        {
            ForEach(LanguageSelection.allCases)
            {
                language in Text(language.rawValue)
                    .tag(language)
            }
        }
        .pickerStyle(.segmented)
    }
}


#Preview
{
//    MainView()
//        .environment(ViewModel())
    VStack
    {
        EmptyView()
    }
    .sheet(isPresented: .constant(true))
    {
        SettingsSheetView()
            .environment(ViewModel())
    }
}
