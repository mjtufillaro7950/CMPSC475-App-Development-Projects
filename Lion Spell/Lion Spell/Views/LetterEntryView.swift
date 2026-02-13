//
//  LetterEntryView.swift
//  Lion Spell
//
//  Created by Michael Tufillaro on 1/25/26.
//

import Foundation
import SwiftUI

struct LetterEntryView: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    
    //make button size, radius, startAngle, and endAngle be computed properties depending on preferences
    //TODO: update these later depending on what the build needs.
    
    
    var radius: CGFloat
    {
        switch manager.preferences.difficulty
        {
        case .easy: return 65
        case .medium: return 55
        case .hard: return 60
        }
    }
    
    var startAngle: Angle
    {
        switch manager.preferences.difficulty
        {
        case .easy: return .degrees(45)
        case .medium: return .degrees(90)
        case .hard: return .degrees(90)
        }
    }
    
    var endAngle: Angle
    {
        return self.startAngle + .degrees(360)
    }
    
    
    //var radius: CGFloat = 50
    //let startAngle: Angle = .degrees(45)
    //let endAngle: Angle = .degrees(405)
    private var deltaAngle: Angle
    {
        .degrees((endAngle.degrees - startAngle.degrees) / Double(manager.scramble.numberOfLetters - 1))
    }
    
    var body: some View
    {
        ZStack
        {
            //first place the required letter
            LetterButton(letter: manager.scramble.requiredLetter, color: .yellow, isRequired: true)
            //call helper method to get a list of the other non-required letters
            let nonRequiredLetters = manager.getNonRequiredLetters()
            
            //loop through all of the non-required letters to place them around the required one
            ForEach(0..<nonRequiredLetters.count, id: \.self)
            {
                index in
                
                //calculate the proper offset depending on the starting angle, ending angle, and number of shapes being placed
                let angle = startAngle + deltaAngle * Double(index)
                let xOffset = cos(angle.radians) * radius
                let yOffset = sin(angle.radians) * radius
                
                //TODO: if the difficulty is medium im gonna have to rotate the pentagon, which will need to be done in such a way that it doesn't also rotate the text on the letters. Might need to move the text part of it out here.
                LetterButton(letter: nonRequiredLetters[index], color: .cyan, isRequired: false)
                    .offset(x: xOffset, y: yOffset)
                
            }
        }
//        HStack
//        {
//            ForEach(manager.lettersForEntry, id: \.self)
//            {
//                letter in
//                // makes the required letter yellow instead of cyan
//                if letter == manager.scramble.requiredLetter
//                {
//                    LetterButton(letter: letter, color: .yellow)
//                }
//                else
//                {
//                    LetterButton(letter: letter, color: .cyan)
//                }
//            }
//        }
    }
}




//TODO: update this to use letterButtonShape and position properly with zstack + offset
struct LetterButton: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    let letter: Character
    let color: Color
    let isRequired: Bool
    var buttonSize: CGFloat
    {
        switch manager.preferences.difficulty
        {
        case .easy: return 80
        case .medium: return 60
        case .hard: return 60
        }
    }
    
    var rotationDegrees: Angle
    {
        if !isRequired && manager.preferences.difficulty == .medium
        {
            return .degrees(36)
        }
        else
        {
            return .degrees(0)
        }
    }
    
    //TODO: make a computed value to adjust font choice and size
    
    var body: some View
    {
        Button
        {
            //adds the current letter into the current word string
            if manager.currentWord.count < 18
            {
                manager.currentWord += String(letter)
            }
        }
        label:
        {
            ZStack
            {
                //TODO: might need to adjust the size/font depending on what difficulty is selected
                //if the letter isn't required and the shape is a pentagon, the pentagon needs to be rotated by 36 degrees to fit the required shape
                LetterButtonShape()
                    .frame(width: buttonSize, height: buttonSize)
                    .foregroundColor(color)
                    .rotationEffect(rotationDegrees)
                Text(String(letter))
                    .foregroundColor(.black)
                    .font(.title)
                    .bold()
                    .textCase(.uppercase)
            }
        }
    }
}

#Preview {
    MainView()
        .environment(ViewModel())
}
