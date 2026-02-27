//  SwiftUIView.swift
//  Pentominoes
//
//  Created by Michael Tufillaro on 2/25/26.
//

import SwiftUI


struct PentominoShape: Shape
{
    //pass in a pentomino outline to base the shape on
    let pentominoOutline: PentominoOutline
    
    func path(in rect: CGRect) -> Path
    {
        //call helper function to create the path for the pentomino
        let outline = pentominoOutline.outline
        let outlineWidth = pentominoOutline.size.width
        let outlineHeight = pentominoOutline.size.height
        
        let path = buildPathFromOutline(outline: outline, outlineWidth: outlineWidth, outlineHeight: outlineHeight, in: rect)
        return path
    }
}


//Preview struct for testing purposes
struct PentominoPreview: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    var body: some View
    {
        VStack
        {
            Spacer()
            Text("Pentomino Shapes:")
            //for each outline, make a pentomino shape
            ScrollView
            {
                ForEach(manager.pentominoOutlines, id: \.name)
                {
                    outline in
                    PentominoShape(pentominoOutline: outline)
                        //the frame size is the width/height in number of blocks multiplied by the size of the blocks
                        .frame(width: manager.blockSize * CGFloat(outline.size.width), height: manager.blockSize * CGFloat(outline.size.height))
                        .foregroundColor(.purple)
                }
            }
            Spacer()
        }
    }
}

#Preview
{
    PentominoPreview()
        .environment(ViewModel())
}
