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
        case .easy: return 62
        case .medium: return 71
        case .hard: return 75
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
    
    //for some reason I cannot figure out, the pentagons specifically are all shifted about 2 units further to the left than they should be. this is my fix because it would be too much work to find the error
    var extraXOffset: Double
    {
        switch manager.preferences.difficulty {
        case .easy:
            return 0
        case .medium:
            return 2.5
        case .hard:
            return 0
        }
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
                let xOffset = cos(angle.radians) * radius + extraXOffset
                let yOffset = sin(angle.radians) * radius

                LetterButton(letter: nonRequiredLetters[index], color: .cyan, isRequired: false)
                    .offset(x: xOffset, y: yOffset)
                
            }
        }
    }
}



struct LetterButton: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    let letter: Character
    let color: Color
    let isRequired: Bool
    let buttonSize: CGFloat = 80
    
    //the non-required letter pentagons need to be rotated 36 degrees to line up with the middle one
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
    
    //similarly, the non-required pentagons text is slightly off so it needs to be adjusted
    var textXOffset: CGFloat
    {
        if !isRequired && manager.preferences.difficulty == .medium
        {
            return -2
        }
        else
        {
            return 0
        }
    }
    
    //all pentagons need to have their text shifted slightly down
    var textYOffset: CGFloat
    {
        if manager.preferences.difficulty == .medium
        {
            return 4
        }
        else
        {
            return 0
        }
    }
    
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
                //if the letter isn't required and the shape is a pentagon, the pentagon needs to be rotated by 36 degrees to fit the required shape
                LetterButtonShape(difficulty: manager.preferences.difficulty)
                    .frame(width: buttonSize, height: buttonSize)
                    .foregroundColor(color)
                    .rotationEffect(rotationDegrees)
                Text(String(letter))
                    .foregroundColor(.black)
                    .font(.system(size: 40, weight: .heavy, design: .rounded))
                    .bold()
                    .textCase(.uppercase)
                    .offset(x: textXOffset, y: textYOffset)
            }
        }
        //contentShape makes it so the button's hitbox is the shape itself and not a rectangle, which was causing issues with the diamond shaped buttons
        .contentShape(LetterButtonShape(difficulty: manager.preferences.difficulty))
        
    }
}

#Preview {
    MainView()
        .environment(ViewModel())
}
