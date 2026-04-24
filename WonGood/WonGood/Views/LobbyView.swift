//
//  LobbyView.swift
//  WonGood
//
//  Created by Michael Tufillaro on 4/13/26.
//

import SwiftUI

struct LobbyView: View
{
    //declare to access the viewmodel
    @Environment(GameSessionManager.self) var gameSessionManager
    //controls whether the seaching sheet is shown
    @State var showSeachSheet = false
    
    var body: some View
    {
        VStack
        {
            Text("WONGOOD")
                .bold()
                .font(.system(size: 65, design: .serif))
            Spacer()
            HostGameButtonView()
            Spacer()
            JoinGameButtonView(showSearchSheet: $showSeachSheet)
            Spacer()
        }
        .padding()
        .sheet(isPresented: $showSeachSheet)
        {
            SearchScreenView()
        }
    }
}


struct HostGameButtonView: View
{
    //declare to access the viewmodel
    @Environment(GameSessionManager.self) var gameSessionManager
    
    var body: some View
    {
        Button
        {
            //start hosting game
            gameSessionManager.hostGame()
            //move to the view for the host's room
            gameSessionManager.phase = .room
        }
        //TODO: replace placeholder button design
        label:
        {
            ZStack
            {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(.yellow)
                    .frame(width: 150, height: 40)
                HStack
                {
                    Image(systemName: "house.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                    Text("Host Game")
                        .bold()
                }
                .foregroundStyle(.white)
            }
        }
    }
}


struct JoinGameButtonView: View
{
    //pass in binding var
    @Binding var showSearchSheet: Bool
    
    //declare to access the viewmodel
    @Environment(GameSessionManager.self) var gameSessionManager
    
    var body: some View
    {
        Button
        {
            //call join game from viewmodel
            gameSessionManager.joinGame()
            //pull up the search screen Sheet
            showSearchSheet = true
        }
        //TODO: replace placeholder button design
        label:
        {
            ZStack
            {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(.blue)
                    .frame(width: 150, height: 40)
                HStack
                {
                    Image(systemName: "arrowshape.turn.up.right.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                    Text("Join Game")
                        .bold()
                }
                .foregroundStyle(.white)
            }
        }
    }
}
#Preview
{
    LobbyView()
        .environment(GameSessionManager())
}
