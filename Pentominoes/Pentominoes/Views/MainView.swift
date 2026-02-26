//
//  ContentView.swift
//  Pentominoes
//
//  Created by Michael Tufillaro on 2/19/26.
//

import SwiftUI
import Foundation


//quick enum to determine which side of the SideView to build
enum Side
{
    case left
    case right
}


struct MainView: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    var body: some View
    {
        Text("Main View")
        //TODO: implement views here
            //Hstack with 3 vstacks in it
            //first vstack: 4 puzzle buttons and reset button
            //second vstack: Title, puzzle grid, puzzle pieces initial position
            //third vstack: remaining puzzle buttons and solve button
        
        HStack
        {
            SideView(side: .left)
            SideView(side: .right)
        }
        Image("Board0")
            .resizable()
            .frame(width: 120, height: 120)
        
    }
}

#Preview
{
    MainView()
        .environment(ViewModel())
}
