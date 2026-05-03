//
//  SearchScreenView.swift
//  WonGood
//
//  Created by Michael Tufillaro on 4/13/26.
//

import SwiftUI
import MultipeerConnectivity


//Sheet that displays a list of all nearby Host games. Clicking on one leaves the sheet and updates game state, taking you to the room view
struct SearchScreenView: View
{
    //declare to access the viewmodel
    @Environment(GameSessionManager.self) var gameSessionManager
    
    var body: some View
    {

        ScrollView(.vertical)
        {
            Text("Searching For Devices to Join...")
                .font(.title2)
                .bold()
                .foregroundStyle(Color.dealerGray)
            
            //for all hosts that are found, make a button to join them
            ForEach(gameSessionManager.foundHosts, id: \.self)
            {
                host in
                Button
                {
                    //start connecting to the selected host
                    gameSessionManager.connectToHost(host)
                    //update the phase to change the view
                    gameSessionManager.phase = .room
                }
                label:
                {
                    ZStack
                    {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(Color.titleColor)
                            .frame(height: 40)
                        HStack
                        {
                            Image(systemName: "paperplane.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 20)
                            Text("Host: \(host.displayName)")
                                .bold()
                        }
                        .foregroundStyle(.white)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.screenColor)
        .onDisappear
        {
            //when leaving this view, stop searching for rooms and clear the list of found hosts
            gameSessionManager.stopSearching()
        }
    }
}

#Preview
{
    @Previewable @State var manager = GameSessionManager()
        
    SearchScreenView()
        .environment(manager)
        .onAppear
        {
            //make fake testing hosts
            manager.foundHosts = [
                MCPeerID(displayName: "Michael's iPhone"),
                MCPeerID(displayName: "James's iPhone"),
                MCPeerID(displayName: "Tyler's iPhone")
            ]
        }
}
