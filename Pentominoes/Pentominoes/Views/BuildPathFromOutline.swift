//
//  ShapePathBuilder.swift
//  Pentominoes
//
//  Created by Michael Tufillaro on 2/25/26.
//

import SwiftUI


//helper function for PentominoShape and PuzzleShape that makes a path based on a shape's outline, width in blocks, and height in blocks
func buildPathFromOutline(outline: Outline, outlineWidth: Int, outlineHeight: Int, in rect: CGRect) -> Path
{
    var path = Path()
    //calculate the width and height of each block depending on the rect size and width/height of the outline
    let blockWidth: CGFloat = rect.width / CGFloat(outlineWidth)
    let blockHeight: CGFloat = rect.height / CGFloat(outlineHeight)
    //the first point needs to be different, keep bool to tell
    var isFirst = true
    //loop through each outline, which is an array of points
    for point in outline
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

