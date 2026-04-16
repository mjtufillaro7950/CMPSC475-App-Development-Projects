//
//  MainView.swift
//  WonGood
//
//  Created by Michael Tufillaro on 4/14/26.
//

import SwiftUI

struct MainView: View
{
    //declare to access the viewmodel
    @Environment(GameSessionManager.self) var gameSessionManager
    
    var body: some View
    {
        VStack
        {
            //show dealer in top part of screen
            DealerView()
            //show different views depending on phase of game session
            switch gameSessionManager.phase
            {
                case .lobby:    LobbyView()
                case .room:     RoomView()
                case .shuffle:  ShuffleView()
                case .results:  ResultsView()
            }
        }
        .background(Color.tableColor)
    }
}

#Preview
{
    MainView()
        .environment(GameSessionManager())
}
