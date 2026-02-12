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
            return path
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
        LetterButtonShape()
            .foregroundColor(.purple)
            .frame(width: 90, height: 90)
    }
}

#Preview
{
    PreviewView()
        .environment(ViewModel())
}
