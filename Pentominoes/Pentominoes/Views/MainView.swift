//
//  ContentView.swift
//  Pentominoes
//
//  Created by Michael Tufillaro on 2/19/26.
//

import SwiftUI
import Foundation

struct MainView: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    var body: some View
    {
        HStack
        {
            SideView(side: .left)
            //middle view goes here
            Text("PENTOMINOES")
            SideView(side: .right)
        }
    }
}

#Preview
{
    MainView()
        .environment(ViewModel())
}
