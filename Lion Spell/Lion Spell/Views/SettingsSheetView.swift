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
    var body: some View
    {
        //wrap everything in a navigation stack so the hints can use navigation links
        NavigationStack
        {
            //make the view vertically scrollable
            ScrollView
            {
                VStack
                {
                    Text("Choose Difficulty:")
                        .bold()
                        .foregroundColor(.black)
                    DifficultyPickerView()
                    Text("Choose Language:")
                        .bold()
                        .foregroundColor(.black)
                    LanguagePickerView()
                    HintsView()
                }
                .padding()
            }
            .background(DesignConstants.lighterColor)
        }
    }
}


struct HintsView: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    //state variable that controls if the hints are being shown or not
    
    //TODO: change this to false!!!!!
    
    @State var showHints = true

    var body: some View
    {
        VStack
        {
            //Toggle that triggers the hints to appear
            Toggle("Show Hints:", isOn: $showHints)
                .tint(DesignConstants.accentColorOne)
                .bold()
            if showHints
            {
                PossiblePointsView()

                NumberOfWordsView()
                
                NumberOfPangramsView()
                .padding(.bottom, 20)
                
                Text("Words by length and starting letter:")

                //this accesses the manager to find the number of words for each length and starting letter, and does a ForEach on every word length
                ForEach(manager.scramble.wordsByNumAndStart, id: \.0)
                {
                    lengthTuple in
                    let numberOfLetters = lengthTuple.0
                    let numberOfWords = lengthTuple.1
                    let letterGroups = lengthTuple.2
                    
                    //for each number of letters, display how many words start with each letter
                    DisclosureGroup("\(numberOfLetters)-Letter Words: \(numberOfWords)")
                    {
                        HStack
                        {
                            ForEach(letterGroups, id: \.0)
                            {
                                letterTuple in
                                let currentLetter = letterTuple.0
                                let listOfWords = letterTuple.1
                                //TODO: this  causes it to take so long it doesn't load, so rip to the time I spend doing it
//                                //also include a grid display of all relavent words
//                                NavigationLink("\(currentLetter): \(listOfWords.count)")
//                                {
//                                    GridDisplayView(listOfWords: listOfWords)
//                                        .navigationTitle("\(numberOfLetters)-Letter Words That Start With \"\(currentLetter.upperCased())\"")
//                                }
                                //TODO: replace this with a good lookin' view
                                Text("\(currentLetter): \(listOfWords.count)")
                                    .textCase(.uppercase)
                            }
                        }
                        .padding()
                    }
                }
            }
        }
    }
}


struct PossiblePointsView: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    var body: some View
    {
        ZStack
        {
            RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                .foregroundColor(DesignConstants.mainColor)
                .frame(height: 30)
            Text("Total Possible Points: \(manager.scramble.maxPossibleScore)")
                .bold()
        }
        
    }
}


struct NumberOfWordsView: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    var body: some View
    {
        ZStack
        {
            RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                .foregroundColor(DesignConstants.accentColorOne)
                .frame(height: 30)
            //creates a link to the separate page where it shows all legal words
            NavigationLink("Number of Words (\(manager.scramble.numberOfLegalWords))                                  >")
            {
                GridDisplayView(listOfWords: Array(manager.scramble.legalWords))
                    .navigationTitle("All Possible Words")
            }
            .foregroundColor(.black)
            .bold()
        }
    }
}


struct NumberOfPangramsView: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    
    var body: some View
    {
        ZStack
        {
            RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                .foregroundColor(DesignConstants.accentColorOne)
                .frame(height: 30)
            //creates a link to page where it shows all pangrams
            NavigationLink("Total Possible Pangrams (\(manager.scramble.allPossiblePangrams.count))                        >")
            {
                GridDisplayView(listOfWords: Array(manager.scramble.allPossiblePangrams))
                    .navigationTitle("All Possible Pangrams")
            }
            .foregroundColor(.black)
            .bold()
        }
    }
}


//use a scrollable lazy vertial grid to display an array of words
struct GridDisplayView: View
{
    let listOfWords: [String]
    //declare 3 GridItems so the grid forms a 3-column display
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    //use a scrollable lazy vertial grid to display the words
    var body: some View
    {
        ScrollView
        {
            LazyVGrid(columns: columns)
            {
                ForEach(listOfWords, id: \.self)
                {
                    word in
                    //creates a rounded rectangle to house the word
                    ZStack
                    {
                        RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                            .frame(height: 50)
                            .foregroundColor(DesignConstants.lighterColor)
                        
                        //makes it scrollable so long words can still fit
                        ScrollView(.horizontal)
                        {
                            HStack
                            {
                                Spacer()
                                Text(word)
                                    .textCase(.uppercase)
                                    .bold()
                                    .font(.default)
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
        }
        .padding()
        .background(DesignConstants.mainColor)
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
        .colorMultiply(DesignConstants.accentColorOne)
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
        .colorMultiply(DesignConstants.accentColorOne)
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
