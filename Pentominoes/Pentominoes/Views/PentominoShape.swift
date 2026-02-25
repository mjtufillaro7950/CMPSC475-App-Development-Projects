//  SwiftUIView.swift
//  Pentominoes
//
//  Created by LiasPub on 2/25/26.
//

import SwiftUI


struct PentominoShape: Shape
{
    //pass in a pentomino outline to base the shape on
    let pentominoOutline: PentominoOutline
    
    func path(in rect: CGRect) -> Path
    {
        var path = Path()
        //calculate the width and height of each block depending on the rect size and width/height of the outline
        let blockWidth: CGFloat = rect.width / CGFloat(pentominoOutline.size.width)
        let blockHeight: CGFloat = rect.height / CGFloat(pentominoOutline.size.height)
        //the first point needs to be different, keep bool to tell
        var isFirst = true
        //loop through each outline, which is an array of points
        for point in pentominoOutline.outline
        {
            //find the x and y coordinates of the next point on the shape depending on the block size and the x/y values of the outline's current point
            let currentX = CGFloat(point.x) * blockWidth
            let currentY = CGFloat(point.y) * blockHeight
            //if its the first point in the shape, move to the starting position
            if isFirst
            {
                path.move(to: CGPoint(x: currentX, y: currentY))
            }
            //otherwise move to the next point
            else
            {
                path.addLine(to: CGPoint(x: currentX, y: currentY))
            }
            //ensure that isFirst is false after the first pass
            isFirst = false
        }
        return path
    }
}


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
