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
                
                //TODO: I need to make each letter appear in its own little box, with the required letter being its own color
                Text(manager.currentWord)
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
