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
            Spacer()
            VStack
            {
                PlayerCardSlotsView()
                    .offset(y: -25)
                Spacer()
            }
            
            Spacer()
            Spacer()
            
            VStack
            {
                //Spacer()
                Text("Tap to Enter\n  Card Info:")
                    .lineLimit(2)
                    .bold()
                    .foregroundStyle(.black)
                    .font(.title3)
                    //need to adjust frame so it fits on two lines
                    .frame(height: 50)
                    
                //button that opens the card customization
                Button
                {
                    showCustomizationSheet = true
                }
                label:
                {
                    //make the button look like the local player's card, or a default one if there isn't a player card
                    PlayerCardView(
                        cardWidth: 125,
                        player: gameSessionManager.localPlayer ?? Player(id: UUID())
                    )
                }
                //space out the player card button and the results button
                //.padding(.bottom, 50)
                Spacer()
                
                //calculate button is only enabled for host
                Button
                {
                    gameSessionManager.lockAndCalculate()
                }
                //TODO: replace placeholder button design
                label:
                {
                    ZStack
                    {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(Color.titleColor)
                            .frame(width: 150, height: 40)
                        HStack
                        {
                            Image(systemName: "pencil.and.outline")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 20)
                            Text("Get Results")
                                .bold()
                        }
                        .foregroundStyle(.white)
                    }
                }
                .disabled(!gameSessionManager.isHost)
                
                Button
                {
                    gameSessionManager.leaveGame()
                }
                //TODO: replace placeholder button design
                label:
                {
                    ZStack
                    {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(Color.titleColor)
                            .frame(width: 150, height: 40)
                        HStack
                        {
                            Image(systemName: "arrowshape.turn.up.left.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 20)
                            Text("Leave Room")
                                .bold()
                        }
                        .foregroundStyle(.white)
                    }
                }
                
                Spacer()
            }
            Spacer()
        }
        .frame(maxHeight: .infinity)
        .padding()
        .sheet(isPresented: $showCustomizationSheet)
        {
            CardCustomizationView(showCustomizationSheet: $showCustomizationSheet)
        }
    }
}


struct PlayerCardSlotsView: View
{
    //declare to access the viewmodel
    @Environment(GameSessionManager.self) var gameSessionManager
    var body: some View
    {
        //TODO: move all the card stuff into its own view
        let slotCardWidth: CGFloat = 65
        let layout = CardLayout(cardWidth: slotCardWidth)
        
        //need to declare this here so the view properly resets when manager.players changes
        let others = gameSessionManager.otherPlayers
        //make an array of other players, padded out to 8 if fewer
        let slots = gameSessionManager.returnRoomSlotArray(others: others)
        
        //make rows of GridItem for LazyHGrid
        let rows = [GridItem(.fixed(layout.cardHeight)), GridItem(.fixed(layout.cardHeight)), GridItem(.fixed(layout.cardHeight)), GridItem(.fixed(layout.cardHeight))]
        //show all other players cards on left, or a blank placeholder if there's not a player there
        LazyHGrid(rows: rows)
        {
            ForEach(slots.indices, id: \.self)
            { index in
                //TODO: host needs ability to remove player from manager.players and resync player lists when clicking on one of the card views
                //TODO: add a sheet that gets pulled up when clicking on a card- makes it big and has button to remove it once thats implemented
                RoomCardView(cardWidth: slotCardWidth, player: slots[index])
            }
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
