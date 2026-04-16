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
    @State var showCustomizationSheet: Bool = false
    
    var body: some View
    {
        //This should have a list of all players in the room on the left, a version of your customizable card on the right (when tapped takes you to a customization view Sheet), and the host needs a button to start calculating
        VStack
        {
            Text("Placeholder Room View")
            Spacer()
            //TODO: display every connected user that has submitted their info (ForEach on manager.players)
            Text("Players with submitted info:")
            //TODO: replace this with card themed view
            ForEach(gameSessionManager.players)
            {
                player in
                Text("\(player.name), \(player.balance)")
            }
            //Placeholder button to leave the room
            //TODO: need to remove player from manager.players and resync player lists when a non-host player leaves
            Button("Leave Room")
            {
                gameSessionManager.leaveGame()
            }
            Button("Enter Info/Customize Card")
            {
                showCustomizationSheet = true
            }
            //TODO: add a button that starts calcualting
                //need to somehow make sure that everyone has submitted a Player object if they wanna be included
                //users wont be added to the list of players UNTIL they submit stuff- could cause issues if the host hits the button to calcualte when not everyone in the room is in the list of players
                //TODO: check if there's a way to compare the number of connected peers to the list of players
            //button is only enabled for host
            Button("Start Calculating")
            {
                gameSessionManager.lockAndCalculate()
            }
            .disabled(!gameSessionManager.isHost)
            
            Spacer()
        }
        .sheet(isPresented: $showCustomizationSheet)
        {
            CardCustomizationView(showCustomizationSheet: $showCustomizationSheet)
        }
    }
}

#Preview
{
    RoomView()
        .environment(GameSessionManager())
}
