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
            RegButton(text: "Delete", color: .red, isButtonDisabled: manager.isDeleteDisabled(), action: manager.deleteButton)
                .padding(.trailing, 50)
            RegButton(text: "Enter", color: .green, isButtonDisabled: manager.isEnterDisabled(), action: manager.enterButton)
        }
        Spacer()
        HStack
        {
            RegButton(text: "Shuffle", color: .indigo, isButtonDisabled: false, action: manager.shuffleButton)
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




#Preview
{
    MainView()
        .environment(ViewModel())
}
