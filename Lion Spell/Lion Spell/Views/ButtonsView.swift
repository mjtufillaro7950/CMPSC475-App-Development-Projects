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
    let buttonSpacing: CGFloat = 50
    
    let enterColor: Color = DesignConstants.accentColorTwo
    let deleteColor: Color = DesignConstants.accentColorTwo
    let shuffleColor: Color = DesignConstants.accentColorOne
    let restartColor: Color = DesignConstants.accentColorOne
    
    var body: some View
    {
        //for all four types of buttons, feed it display text, a color, a condition if it needs to be disabled, and an action to take once it is pressed
        HStack
        {
            RegButton(text: "Delete", color: deleteColor, isButtonDisabled: manager.isDeleteDisabled(), action: manager.deleteButton)
                .padding(.trailing, buttonSpacing)
            RegButton(text: "Enter", color: enterColor, isButtonDisabled: manager.isEnterDisabled(), action: manager.enterButton)
        }

        HStack
        {
            //these buttons do not need to be disabled so just pass false
            RegButton(text: "Shuffle", color: shuffleColor, isButtonDisabled: false, action: manager.shuffleButton)
            Spacer()
            SettingsButton(showSettings: $showSettings)
            Spacer()
            RegButton(text: "Restart", color: restartColor, isButtonDisabled: false, action: manager.restartButton)
        }
        .padding()
    }
    
}

struct RegButton: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    
    let text: String
    let color: Color
    var isButtonDisabled: Bool
    //lets the program take an function as a parameter
    let action: () -> Void
    let buttonWidth: CGFloat = 100
    let buttonHeight: CGFloat = 50
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
                RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                    .frame(width: buttonWidth, height: buttonHeight)
                    //make the button be gray if it is disabled, otherwise use its passed in color
                    .foregroundColor(isButtonDisabled ? Color.gray.opacity(0.6) : color)
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
    let gearSize: CGFloat = 50
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
                .frame(width: gearSize, height: gearSize)
                .background(Circle().fill(.black))
                
        }
    }
}

#Preview
{
    MainView()
        .environment(ViewModel())
}
