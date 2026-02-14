//
//  CurrentWordView.swift
//  Lion Spell
//
//  Created by Michael Tufillaro on 1/25/26.
//

import SwiftUI

struct CurrentWordView: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    let currentWordHeight: CGFloat = 75
    
    var body: some View
    {
        VStack
        {
            // I don't know why but if I don't have this here, the rectangle shifts upon text entry
            Text(" ")
            
            ZStack
            {
                RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                    .frame(height: currentWordHeight)
                    .foregroundColor(DesignConstants.lighterColor)
                HStack(spacing: 2)
                {
                    //for each letter in the current word, display it- need to do this so it can be colored properly
                    ForEach(0..<manager.currentWord.count, id: \.self)
                    {
                        index in
                        let character: Character = Array(manager.currentWord)[index]
                        //call helper method to determine the current letter's color
                        let colors = DesignConstants.currentLetterColors(character: character, requiredLetter: manager.scramble.requiredLetter)
                        
                        ZStack
                        {
                            RoundedRectangle(cornerRadius: DesignConstants.cornerRadius/4)
                                .foregroundColor(colors.0)
                                .frame(width: 30, height: 30)
                            Text(String(character))
                                .foregroundColor(colors.1)
                                .textCase(.uppercase)
                                .bold()
                                .font(.title)
                        }
                    }
                }
            }
            
            //updates the user feedback depending on what word the user has entered
            Text(manager.updateFeedback())
                .font(.headline)
                .bold()
                .foregroundColor(.black)
        }
    }
}

#Preview
{
    MainView()
        .environment(ViewModel())
}
