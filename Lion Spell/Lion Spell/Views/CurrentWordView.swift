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
                
                Text(manager.currentWord)
                    .foregroundColor(.black)
                    .textCase(.uppercase)
                    .bold()
                    .font(.title)
                    
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
