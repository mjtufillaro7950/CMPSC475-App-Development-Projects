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
    let frameHeight: CGFloat = 30
    //state variable that controls if the hints are being shown or not
    @State var showHints = false

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
                PossiblePointsView(frameHeight: frameHeight)

                NumberOfWordsView(frameHeight: frameHeight)
                
                NumberOfPangramsView(frameHeight: frameHeight)
                .padding(.bottom, 20)
                
                WordsByNumberAndLetterView()
            }
        }
    }
}

//displays the total possible points
struct PossiblePointsView: View
{
    var frameHeight: CGFloat
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    var body: some View
    {
        ZStack
        {
            RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                .foregroundColor(DesignConstants.accentColorOne)
                .frame(height: frameHeight)
            Text("Total Possible Points: \(manager.scramble.maxPossibleScore)")
                .bold()
        }
        
    }
}


//displays the total number of words and links to a page to show them
struct NumberOfWordsView: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    var frameHeight: CGFloat
    var body: some View
    {
        ZStack
        {
            RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                .foregroundColor(DesignConstants.accentColorOne)
                .frame(height: frameHeight)
            //creates a link to the separate page where it shows all legal words
            NavigationLink("Total Number of Legal Words (\(manager.scramble.numberOfLegalWords))   >")
            {
                GridDisplayView(listOfWords: Array(manager.scramble.legalWords))
                    .navigationTitle("All Possible Words")
            }
            .foregroundColor(.black)
            .bold()
        }
    }
}


//displays the number of pangrams and links to a page to see them
struct NumberOfPangramsView: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    var frameHeight: CGFloat
    
    var body: some View
    {
        ZStack
        {
            RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                .foregroundColor(DesignConstants.accentColorOne)
                .frame(height: frameHeight)
            //creates a link to page where it shows all pangrams
            NavigationLink("Total Possible Pangrams (\(manager.scramble.allPossiblePangrams.count))   >")
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


struct WordsByNumberAndLetterView: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    var body: some View
    {
        
        Text("Words by length and starting letter:")
            .bold()

        //this accesses the manager to find the number of words for each length and starting letter, and does a ForEach on every word length
        ForEach(manager.scramble.wordsByNumAndStart, id: \.0)
        {
            lengthTuple in
            let numberOfLetters = lengthTuple.0
            let numberOfWords = lengthTuple.1
            let letterGroups = lengthTuple.2
            
            ZStack
            {
                RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                    .foregroundColor(DesignConstants.mainColor)
                //for each number of letters, display how many words start with each letter
                DisclosureGroup("\(numberOfLetters)-Letter Words: \(numberOfWords)")
                {
                    ScrollView(.horizontal)
                    {
                        HStack
                        {
                            ForEach(letterGroups, id: \.0)
                            {
                                letterTuple in
                                let currentLetter = letterTuple.0
                                let listOfWords = letterTuple.1
                                
                                ZStack
                                {
                                    RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                                        .foregroundColor(DesignConstants.lighterColor)
                                        .frame(width: 50)
                                    Text("\(String(currentLetter)): \(listOfWords.count)")
                                        .textCase(.uppercase)
                                        .font(.body)
                                }
                            }
                        }
                    }
                }
                .foregroundColor(.black)
                .bold()
                .font(.title3)
                .padding(10)
            }
        }
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
