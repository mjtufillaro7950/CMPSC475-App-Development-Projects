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
        //TODO: hook up the host game button and the join game button to their proper functions. Make the searching screen be a Sheet because at any point you should be able to go back and pick Host if you want.!!!!!!!!!!!!!!!!!!!!!
        
        //TODO: make sure that when leaving said search screen sheet, you stop searching
        
        VStack
        {
            //TODO: make a dedicated view for the dealer top half of the screen, maybe have a "current dealer image" property in viewmodel that it can reference to make updating it easier
            Image("DefaultPlaceholder")
                .resizable().scaledToFit()
                .ignoresSafeArea()
            //TODO: make a much better looking title, probably even a dedicated image instead of text
            Text("WONGOOD")
                .font(.title).bold()
            Spacer()
            Spacer()
            HostGameButtonView()
            Spacer()
            JoinGameButtonView(showSearchSheet: $showSeachSheet)
            Spacer()
        }
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
            //TODO: do host game stuff here
            gameSessionManager.hostGame()
            //move to the view for the host's room
            gameSessionManager.phase = .collectingData
        }
        label:
        {
            ZStack
            {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(.green)
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
            //TODO: update this?
            //call join game from viewmodel
            gameSessionManager.joinGame()
            //pull up the search screen Sheet
            showSearchSheet = true
        }
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
