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
    
    var body: some View
    {
        VStack
        {
            // I don't know why but if I don't have this here, the rectangle shifts upon text entry
            Text(" ")
            
            ZStack
            {
                RoundedRectangle(cornerRadius: 16)
                    .frame(height: 75)
                    .foregroundColor(.cyan)
                
                //needs to be able to fit 18 letters, since that is the length of the longest possible word that uses 7 or fewer unique letters
                Text(manager.currentWord)
                    .textCase(.uppercase)
                    .bold()
                    .font(.title)
                    
            }
            //updates the user feedback depending on what word the user has entered
            Text(manager.updateFeedback())
                .font(.headline)
                .bold()
        }
    }
}

#Preview
{
    MainView()
        .environment(ViewModel())
}
