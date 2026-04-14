//
//  ContentView.swift
//  WonGood
//
//  Created by Michael Tufillaro on 4/13/26.
//

import SwiftUI

struct HomeScreenView: View
{
    var body: some View
    {
        Image("DefaultPlaceholder")
        Text("WONGOOD")
            .font(.title).bold()
        Spacer()
        HStack
        {
            Spacer()
            HostGameButtonView()
            Spacer()
            JoinGameButtonView()
            Spacer()
        }
        .padding()
    }
}


struct HostGameButtonView: View
{
    var body: some View
    {
        Button
        {
            //TODO: do host game stuff here
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
    var body: some View
    {
        Button
        {
            //TODO: do join game stuff here
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
    HomeScreenView()
}
