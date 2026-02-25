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
        VStack
        {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview
{
    MainView()
        .environment(ViewModel())
}
