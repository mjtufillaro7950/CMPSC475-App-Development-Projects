//
//  LetterEntryShape.swift
//  Lion Spell
//
//  Created by LiasPub on 2/12/26.
//

import SwiftUI

//TODO: custom letterButtonShape struct that changes depending on the number of letters
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
            //the distance from the sides that the upper left/right points need to be
            let upperOffset = width * 0.25
            //the distance from the sides that the bottom left/right points need to be
            let lowerOffset = width * 0.25
            //how far from the top the upper 2 points are
            let upperHeight = height * 0.25
            //start at top middle
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            //move to upper right point
            path.addLine(to: CGPoint(x: rect.maxX - upperOffset, y: rect.minY + upperHeight))
            //lower right point
            path.addLine(to: CGPoint(x: rect.maxX - lowerOffset, y: rect.maxY))
            //lower left point
            path.addLine(to: CGPoint(x: rect.minX + lowerOffset, y: rect.maxY))
            //upper left point
            path.addLine(to: CGPoint(x: rect.minX + upperOffset, y: rect.minY + upperHeight))
            //then close subpath (finish last line)
            path.closeSubpath()
            
        case .hard:
            //make a hexagon
            return path
        }
        return path
    }
}

//TODO: test view to display letters
struct PreviewView: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    
    var body: some View
    {
        ZStack
        {
            Rectangle()
                .foregroundColor(.gray)
                .frame(width: 90, height: 90)
            LetterButtonShape()
                .foregroundColor(.purple)
                .frame(width: 90, height: 90)
        }
        
    }
}

#Preview
{
    PreviewView()
        .environment(ViewModel())
}
