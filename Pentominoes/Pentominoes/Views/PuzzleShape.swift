//
//  SwiftUIView.swift
//  Pentominoes
//
//  Created by Michael Tufillaro on 2/25/26.
//

import SwiftUI


struct PuzzleShape: Shape
{
    //pass in a puzzle outline
    let puzzleOutline: PuzzleOutline
    
    func path(in rect: CGRect) -> Path
    {
        //since puzzles can have holes, its necessary to generate an path for each continuous outline and then add them together
        var totalPath = Path()
        let outlineWidth: Int = puzzleOutline.size.width
        let outlineHeight: Int = puzzleOutline.size.height
        //loop through each Outline in the puzzle shapes Outlines
        for outline in puzzleOutline.outlines
        {
            //for each outline that makes up the puzzle, call helper method to create a path for it
            let currentPath = buildPathFromOutline(outline: outline, outlineWidth: outlineWidth, outlineHeight: outlineHeight, in: rect)
            
            //then, add the current path to the combined path
            totalPath.addPath(currentPath)
        }
        //once all paths have been combined, return it
        return totalPath
    }
}


//Preview struct for testing purposes
struct PuzzlePreview: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    var body: some View
    {
        VStack
        {
            Spacer()
            Text("Puzzle Shapes:")
            //for each puzzle outline, make a puzzle shape
            ScrollView
            {
                ForEach(manager.puzzleOutlines, id: \.name)
                {
                    outline in
                    PuzzleShape(puzzleOutline: outline)
                        //the frame size is the width/height in number of blocks multiplied by the size of the blocks
                        .fill(Color.purple)
                        .stroke(.black, lineWidth: 5)
                        .frame(width: manager.blockSize * CGFloat(outline.size.width), height: manager.blockSize * CGFloat(outline.size.height))
                        .padding()
                }
            }
            Spacer()
        }
    }
}


#Preview
{
    PuzzlePreview()
        .environment(ViewModel())
}
