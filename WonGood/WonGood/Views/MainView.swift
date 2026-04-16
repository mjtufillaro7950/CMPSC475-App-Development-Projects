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
            //TODO: store dealer view OUT HERE. All four of these below views just change the bottom half of the screen
            DealerView()
            //show different views depending on phase of game session
            switch gameSessionManager.phase
            {
            case .lobby: LobbyView()
            case .collectingData: RoomView()
            case .calculating: ShuffleView()
            case .results: ResultsView()
            }
        }
    }
}

#Preview
{
    MainView()
        .environment(GameSessionManager())
}
