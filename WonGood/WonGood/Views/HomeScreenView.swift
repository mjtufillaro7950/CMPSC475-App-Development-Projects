//
//  ContentView.swift
//  WonGood
//
//  Created by Michael Tufillaro on 4/13/26.
//

import SwiftUI

struct HomeScreenView: View
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
    HomeScreenView()
}
