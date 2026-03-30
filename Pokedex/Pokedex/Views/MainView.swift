//
//  ContentView.swift
//  Pokedex
//
//  Created by Michael Tufillaro on 3/23/26.
//

import SwiftUI

struct MainView: View
{
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
}
