//
//  PentominoView.swift
//  Pentominoes
//
//  Created by LiasPub on 2/27/26.
//

import SwiftUI


//take a PentominoOutline, return a view containing that pentomino filled with the given color and with interior grid lines
struct PentominoView: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    let pentominoOutline: PentominoOutline
    
    var body: some View
    {
        ZStack
        {
            
            PentominoShape(pentominoOutline: pentominoOutline)
                //call Color extension to get the color for the piece
                .fill(Color(pentominoOutline: pentominoOutline))
                //use .overlay to put a grid on top of the shape to get the inner lines
                .overlay(
                    GridShape(gridRows: CGFloat(pentominoOutline.size.height), gridColumns: CGFloat(pentominoOutline.size.width))
                        .stroke(.black, lineWidth: 2)
                        //clip the shape to the shape of the pentomino
                        .clipShape(PentominoShape(pentominoOutline: pentominoOutline))
                )
            
            //add another outline on top to get the outer outline to be the right width
            PentominoShape(pentominoOutline: pentominoOutline)
                .stroke(.black, lineWidth: 2)
        }
    }
}


//for testing purposes
struct PentominoViewPreview: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    
    var body: some View
    {
        //for each outline, make a pentomino shape
        ScrollView
        {
            ForEach(manager.pentominoOutlines, id: \.name)
            {
                outline in
                PentominoView(pentominoOutline: outline)
                    //the frame size is the width/height in number of blocks multiplied by the size of the blocks
                    .frame(width: manager.blockSize * CGFloat(outline.size.width), height: manager.blockSize * CGFloat(outline.size.height))
            }
        }
    }
}
#Preview
{
    PentominoViewPreview()
        .environment(ViewModel())
}
