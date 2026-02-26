//
//  SideView.swift
//  Pentominoes
//
//  Created by Michael Tufillaro on 2/26/26.
//

import SwiftUI


//this is a view representing the left and right side of the screen
struct SideView: View
{
    //this determines if its building the left or right side of the view
    let side: Side
    
    var body: some View
    {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct preView: View
{
    var body: some View
    {
        HStack
        {
            SideView(side: .left)
            SideView(side: .right)
        }
        .padding()
    }
}

#Preview
{
    preView()
}
