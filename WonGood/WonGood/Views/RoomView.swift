//
//  RoomView.swift
//  WonGood
//
//  Created by Michael Tufillaro on 4/13/26.
//

import SwiftUI

struct RoomView: View
{
    //declare to access the viewmodel
    @Environment(GameSessionManager.self) var gameSessionManager
    
    var body: some View
    {
        //This should have a list of all players in the room on the left, a version of your customizable card on the right (when tapped takes you to a customization view Sheet), and the host needs a button to start calculating
        Text("Room View")
        Button("Leave Room")
        {
            gameSessionManager.leaveGame()
        }
    }
}

#Preview
{
    RoomView()
        .environment(GameSessionManager())
}
