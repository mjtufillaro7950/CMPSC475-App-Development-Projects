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
            //make a shadow effect with the logo by duplicating it in black
            ZStack
            {
                LogoView()
                    .foregroundStyle(.black)
                    .offset(x: -2, y: 2)
                LogoView()
                    .foregroundStyle(Color.titleColor)
            }
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
                //only pulls the sheet halfway up instead of all the way up
                .presentationDetents([.medium])
        }
    }
}


struct LogoView: View
{
    var body: some View
    {
        VStack(spacing: 0)
        {
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 340, height: 5)
            
            Text("WonGood")
                //shrink the text if it doesn't fit on one line
                .font(.system(size: 75, design: .serif))
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .bold()
            
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 340, height: 5)
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
        label:
        {
            GenericButtonLabel(buttonText: "Host Game", systemImageName: "house.fill")
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
            //call join game from viewmodel to start searching for rooms
            gameSessionManager.joinGame()
            //pull up the search screen Sheet
            showSearchSheet = true
        }
        label:
        {
            GenericButtonLabel(buttonText: "Join Game", systemImageName: "arrowshape.turn.up.right.fill")
        }
    }
}

#Preview
{
    MainView()
        .environment(GameSessionManager())
}
