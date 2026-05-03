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
    var cardText: String
    {
        if let _ = gameSessionManager.localPlayer
        {
            return "Tap to Enter\nAdditional Card:"
        }
        return "Tap to Enter\nCard Info:"
    }

        
    var body: some View
    {
        HStack
        {
            Spacer()
            VStack
            {
                //display all the connected players cards in a grid
                PlayerCardSlotsView()
                    .offset(y: -25)
                Spacer()
            }
            
            Spacer()
            Spacer()
            
            VStack
            {
                Text(cardText)
                    .minimumScaleFactor(0.5)
                    .lineLimit(3)
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.dealerGray)
                    .font(.title3)
                    //need to adjust frame so it fits on two lines
                    .frame(width: 120, height: 50)
                    
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
                //disable adding more cards if the max is reached
                .disabled(gameSessionManager.players.count >= 9)
                .opacity(gameSessionManager.players.count >= 9 ? 0.4: 1)
                //add ability for host to long press on card view to remove it
                .contextMenu
                {
                    //ensure that only the host can remove cards, and that the card being tapped on exists
                    if gameSessionManager.isHost, let player = gameSessionManager.localPlayer
                    {
                        Button(role: .destructive)
                        {
                            gameSessionManager.removePlayer(player: player)
                        }
                        label:
                        {
                            //TODO: this is default form from documentation, change later?
                            Label("Remove \(player.name)'s Card", systemImage: "trash")
                        }
                    }
                
                }
                
                
                Spacer()
                
                //calculate button is only enabled for host
                Button
                {
                    gameSessionManager.lockAndCalculate()
                }
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
                .opacity(!gameSessionManager.isHost ? 0.4: 1)
                
                Button
                {
                    gameSessionManager.leaveGame()
                }
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
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .presentationBackground(Color.screenColor)  
        }
    }
}


struct PlayerCardSlotsView: View
{
    //declare to access the viewmodel
    @Environment(GameSessionManager.self) var gameSessionManager
    var body: some View
    {
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
            {
                index in
                RoomCardView(cardWidth: slotCardWidth, player: slots[index])
                    //add ability for host to long press on card view to remove it
                    .contextMenu
                    {
                        //ensure that only the host can remove cards, and that the card being tapped on exists
                        if gameSessionManager.isHost, let player = slots[index]
                        {
                            Button(role: .destructive)
                            {
                                gameSessionManager.removePlayer(player: player)
                            }
                            label:
                            {
                                //TODO: this is default form from documentation, change later?
                                Label("Remove \(player.name)'s Card", systemImage: "trash")
                            }
                        }
                    
                    }
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
