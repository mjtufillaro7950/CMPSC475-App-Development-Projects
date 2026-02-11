//
//  ButtonsView.swift
//  Lion Spell
//
//  Created by Michael Tufillaro on 1/25/26.
//

import SwiftUI

struct ButtonsView: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    @Binding var showSettings: Bool
    var body: some View
    {
        //for all four types of buttons, feed it display text, a color, a condition if it needs to be disabled, and an action to take once it is pressed
        HStack
        {
            RegButton(text: "Delete", color: .red, isButtonDisabled: manager.isDeleteDisabled(), action: manager.deleteButton)
                .padding(.trailing, 50)
            RegButton(text: "Enter", color: .green, isButtonDisabled: manager.isEnterDisabled(), action: manager.enterButton)
        }
        Spacer()
        HStack
        {
            RegButton(text: "Shuffle", color: .indigo, isButtonDisabled: false, action: manager.shuffleButton)
            Spacer()
            SettingsButton(showSettings: $showSettings)
            Spacer()
            RegButton(text: "Restart", color: .yellow, isButtonDisabled: false, action: manager.restartButton)
        }
        .padding()
    }
    
}

struct RegButton: View
{
    let text: String
    let color: Color
    var isButtonDisabled: Bool
    //lets the program take an function as a parameter
    let action: () -> Void
    var body: some View
    {
        Button
        {
            action()
        }
        label:
        {
            ZStack
            {
                RoundedRectangle(cornerRadius: 16)
                    .frame(width: 100, height: 50)
                    .foregroundColor(color)
                Text(text)
                    .foregroundColor(.black)
                    .font(.title2)
            }
        }
        .disabled(isButtonDisabled)
    }
}

//creates a button that toggles the user settings
struct SettingsButton: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    //pass down state var again
    @Binding var showSettings: Bool
    var body: some View
    {
        Button
        {
            //toggle the settings to be shown when button is pressed
            showSettings = true
        }
        label:
        {
            //makes the button look like a circle with a gear on it.
            Image(systemName: "gear")
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(Circle().fill(.black))
                
        }
    }
}




#Preview
{
    MainView()
        .environment(ViewModel())
}
