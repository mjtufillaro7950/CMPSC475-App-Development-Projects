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
    
    //TODO: two VStacks
        //One has space for 9 submitted player names, possibly their card- tapping pulls up their card design
        //One has a button to add a card, then the calculate and leave room buttons
        
    var body: some View
    {
        HStack
        {
            
            VStack
            {
                //display every connected user that has submitted their info (ForEach on manager.players)
                Text("Players with submitted info:")
                //TODO: make this a 2x4 lazy grid instead of a scrollview
                ScrollView(.horizontal)
                {
                    HStack
                    {
                        ForEach(gameSessionManager.players)
                        {
                            player in
                            //TODO: host needs ability to remove player from manager.players and resync player lists when clicking on one of the card views
                            PlayerCardView(cardWidth: 125, player: player)
                        }
                        .padding()
                    }
                }
                //.padding()
            }
            
            VStack
            {
                //Make this button look like the player's current card
                Button("Enter Info/Customize Card")
                {
                    showCustomizationSheet = true
                }
                //TODO: need to somehow make sure that everyone has submitted a Player object if they wanna be included
                //users wont be added to the list of players UNTIL they submit stuff- could cause issues if the host hits the button to calcualte when not everyone in the room is in the list of players
                //TODO: check if there's a way to compare the number of connected peers to the list of players
                //calculate button is only enabled for host
                Button("Start Calculating")
                {
                    gameSessionManager.lockAndCalculate()
                }
                .disabled(!gameSessionManager.isHost)
                Spacer()
                Button("Leave Room")
                {
                    gameSessionManager.leaveGame()
                }
            }
        }
        .sheet(isPresented: $showCustomizationSheet)
        {
            CardCustomizationView(showCustomizationSheet: $showCustomizationSheet)
        }
    }
}

#Preview
{
    @Previewable @State var manager = GameSessionManager()
        
    MainView()
        .environment(manager)
        .onAppear
        {
            manager.phase = .room
            manager.players = [
                    Player(
                        id: UUID(),
                        name: "Michael",
                        balance: 50.00,
                        cardCustomizationOptions: CardCustomizationOptions()
                    ),
                    Player(
                        id: UUID(),
                        name: "James",
                        balance: -200.00,
                        cardCustomizationOptions: CardCustomizationOptions()
                    ),
                    Player(
                        id: UUID(),
                        name: "Tufillaro",
                        balance: 150.00,
                        cardCustomizationOptions: CardCustomizationOptions()
                    )
                ]
        }
}
