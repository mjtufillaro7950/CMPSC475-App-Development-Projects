//
//  SearchScreenView.swift
//  WonGood
//
//  Created by Michael Tufillaro on 4/13/26.
//

import SwiftUI

struct SearchScreenView: View
{
    //declare to access the viewmodel
    @State var gameSessionManager = GameSessionManager()
    
    var body: some View
    {
        //TODO: this will be a Sheet that displays a list of all nearby Host games. Clicking on one leaves the sheet and updates game state, taking you to the room view
        Text("Placeholder Search Screen View")
    }
}

#Preview
{
    SearchScreenView()
        .environment(GameSessionManager())
}
