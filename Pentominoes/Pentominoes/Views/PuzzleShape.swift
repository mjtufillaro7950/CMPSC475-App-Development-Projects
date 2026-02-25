//
//  SwiftUIView.swift
//  Pentominoes
//
//  Created by LiasPub on 2/25/26.
//

import SwiftUI


struct PuzzleShape: Shape
{
    func path(in rect: CGRect) -> Path
    {
        var path = Path()
        //similar to last one, except I have to make a new path value for each outline and then use addPath func to combine them into one path
        //if it returns path and its consistent, can I use reusable code for pentomino and puzzle?? maybe
        return path
    }
}
struct PuzzlePreview: View
{
    var body: some View
    {
        Text("Puzzle Shape")
    }
}

#Preview
{
    PuzzlePreview()
}
