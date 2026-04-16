//
//  SearchScreenView.swift
//  WonGood
//
//  Created by Michael Tufillaro on 4/13/26.
//

import SwiftUI
import MultipeerConnectivity

struct SearchScreenView: View
{
    //declare to access the viewmodel
    @Environment(GameSessionManager.self) var gameSessionManager
    
    var body: some View
    {
        //Sheet that displays a list of all nearby Host games. Clicking on one leaves the sheet and updates game state, taking you to the room view

        ScrollView(.vertical)
        {
            Text("Placeholder Search Screen View")
            //for all hosts that are found, make a button to join them
            //TODO: will need to replace and supplement with more info like number of players
            ForEach(gameSessionManager.foundHosts, id: \.self)
            {
                host in
                Button(host.displayName)
                {
                    //start connecting to the selected host
                    gameSessionManager.connectToHost(host)
                    //update the phase to change the view
                    gameSessionManager.phase = .collectingData
                }
            }
        }
        .padding()
        .onDisappear
        {
            //when leaving this view, stop searching for rooms
            gameSessionManager.stopSearching()
        }
    }
}

#Preview
{
    SearchScreenView()
        .environment(GameSessionManager())
}
