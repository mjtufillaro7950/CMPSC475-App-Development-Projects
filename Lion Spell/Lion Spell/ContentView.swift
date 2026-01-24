//
//  ContentView.swift
//  Lion Spell
//
//  Created by LiasPub on 1/24/26.
//

import SwiftUI

struct ContentView: View
{
    var body: some View
    {
        VStack
        {
            HStack
            {
                Text("Lion Spell")
                Spacer()
                Text("Score counter")
            }
            Text("Build your word/Current Word")
            Text("Scrollable list of found words")
            Text("5 different letters")
            Text("Delete and submit")
            Spacer()
        }
        .padding()
    }
}

#Preview
{
    ContentView()
}
