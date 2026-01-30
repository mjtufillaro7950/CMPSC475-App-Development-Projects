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
    
    var body: some View
    {
        HStack
        {
            //TODO: use for each to avoid having to type these out 4 times in a row
            RegButton(text: "Delete", color: .red, action: deleteButton)
                .padding(.trailing, 50)
            RegButton(text: "Enter", color: .green, action: enterButton)
        }
        Spacer()
        HStack
        {
            RegButton(text: "Shuffle", color: .indigo, action: shuffleButton)
            Spacer()
            RegButton(text: "Restart", color: .yellow, action: restartButton)
        }
        .padding()
    }
    
    //TODO: if all of these are just gonna call manager I can probably just pass in the specific function I wanna call instead of having 4 different functions here
    func deleteButton() -> Void
    {
        manager.deleteLetter()
    }

    func enterButton() -> Void
    {
        //TODO: if the word is not in the legal word list OR if the word has already been entered, send feedback to the user. If it's good, then add it to the found words, give positive feedback, & update score
        print("Enter pressed!")
    }

    func shuffleButton() -> Void
    {
        //TODO: randomly change around the positioning of the letters, making sure to keep the required letter highlighted yellow
        print("Shuffle pressed!")
    }

    func restartButton() -> Void
    {
        //TODO: start a new game... how? Probably need to create a new Shuffle() object and reassign the current one in the viewmodel
        //call the newGame function in viewmodel
        print("Restart pressed!")
    }
}

struct RegButton: View
{
    
    let text: String
    let color: Color
    //lets the program take an function as a parameter which takes no parameters and returns nothing
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
    }
}




#Preview
{
    MainView()
        .environment(ViewModel())
}
