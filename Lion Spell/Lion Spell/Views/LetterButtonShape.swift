//
//  LetterEntryShape.swift
//  Lion Spell
//
//  Created by Michael Tufillaro on 2/12/26.
//

import SwiftUI

//custom letterButtonShape struct that changes depending on the number of letters
struct LetterButtonShape: Shape
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    func path(in rect: CGRect) -> Path
    {
        var path = Path()
        //declara variables so I don't have to type it out every time
        let width = rect.width
        let height = rect.height
        //switch statement depending on the difficulty
        switch manager.preferences.difficulty
        {
        case .easy:
            //make a diamond
            //first start at the top middle of the rectangle
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            //then move to the middle right
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            //then bottom middle
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            //then middle left
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            //then close subpath (finish last line)
            path.closeSubpath()
            
        case .medium:
            //make a pentagon
            //declare offsets in order to properly position the lines
            //These contain the offset relative to the center of the square for each point in terms of the width/height (geometry for the win)
            let upperXOffset = width * 0.48
            let lowerXOffset = width * 0.29
            let upperYOffset = height * 0.15
            let lowerYOffset = height * 0.40
            //the spacing is a little off so adjust each point vertically by a little bit
            let verticalOffset = width * 0.05
            
            //start at top middle
            path.move(to: CGPoint(x: rect.midX, y: rect.minY + verticalOffset))
            //draw line to upper right point
            path.addLine(to: CGPoint(x: rect.midX + upperXOffset, y: rect.midY - upperYOffset + verticalOffset))
            //draw line to bottom right
            path.addLine(to: CGPoint(x: rect.midX + lowerXOffset, y: rect.midY + lowerYOffset + verticalOffset))
            //draw line to bottom left
            path.addLine(to: CGPoint(x: rect.midX - lowerXOffset, y: rect.midY + lowerYOffset + verticalOffset))
            //draw line to upper left
            path.addLine(to: CGPoint(x: rect.midX - upperXOffset, y: rect.midY - upperYOffset + verticalOffset))
        
            //then close subpath (finish last line)
            path.closeSubpath()
            
        case .hard:
            //make a hexagon
            //again, make offsets from center of square to make it a perfect hexagon
            let upperAndLowerXOffset = width * 0.25
            let upperAndLowerYOffset = height * 0.43
            //start at upper left point
            path.move(to: CGPoint(x: rect.midX - upperAndLowerXOffset, y: rect.midY - upperAndLowerYOffset))
            //draw line to upper right point
            path.addLine(to: CGPoint(x: rect.midX + upperAndLowerXOffset, y: rect.midY - upperAndLowerYOffset))
            //draw line to right point
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            //draw line to bottom right point
            path.addLine(to: CGPoint(x: rect.midX + upperAndLowerXOffset, y: rect.midY + upperAndLowerYOffset))
            //draw line to bottom left point
            path.addLine(to: CGPoint(x: rect.midX - upperAndLowerXOffset, y: rect.midY + upperAndLowerYOffset))
            //draw line to left point
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            
            //then close subpath (finish last line)
            path.closeSubpath()
        }
        return path
    }
}

//test view to display the shape compared to a square
struct PreviewView: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    
    var body: some View
    {
        let length: CGFloat = 150
        ZStack
        {
            Rectangle()
                .foregroundColor(.gray)
                .frame(width: length, height: length)
            LetterButtonShape()
                .foregroundColor(.purple)
                .frame(width: length, height: length)
        }
        
    }
}

#Preview
{
    PreviewView()
        .environment(ViewModel())
}
