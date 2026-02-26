//
//  GridShape.swift
//  Pentominoes
//
//  Created by Michael Tufillaro on 2/25/26.
//

import SwiftUI


//create the GridShape struct
struct GridShape: Shape
{
    //need to pass in the number of rows and columns in the grid
    let rows: CGFloat
    let columns: CGFloat
    
    func path(in rect: CGRect) -> Path
    {
        var path = Path()
        //the spacing between each row and column depends on the rectangles size and the number of rows/columns
        let rowSpacing: CGFloat = rect.height / rows
        let columnSpacing: CGFloat = rect.width / columns
        
        //use stride to make horizontal lines- moves in equal intervals across the entire rectangle
        for y in stride(from: 0, through: rect.height, by: rowSpacing)
        {
            //for each y equally spaced from 0 to the max, draw a line horizontally across
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: rect.width, y: y))
        }
        
        //same thing for vertical lines
        for x in stride(from: 0, through: rect.width, by: columnSpacing)
        {
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: rect.height))
        }
        return path
    }
}


//view used in preview
struct GridPreview: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    
    let n: CGFloat = 14
    let m: CGFloat = 14
    //computed values that calculate the necessary grid size and width
    var gridWidth: CGFloat
    {
        return manager.blockSize * n
    }
    var gridHeight: CGFloat
    {
        return manager.blockSize * m
    }
    var body: some View
    {
        VStack
        {
            Spacer()
            Text("Grid Shape:")
            GridShape(rows: n, columns: m)
                .stroke(.black, lineWidth: 1)
                .frame(width: gridWidth, height: gridHeight)
            Spacer()
        }
    }
}

#Preview
{
    GridPreview()
        .environment(ViewModel())
}
