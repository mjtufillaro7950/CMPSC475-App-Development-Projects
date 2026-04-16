//
//  DealerView.swift
//  WonGood
//
//  Created by Michael Tufillaro on 4/14/26.
//

import SwiftUI

struct DealerView: View
{
    @Environment(GameSessionManager.self) var gameSessionManager
    
    var body: some View
    {
        //TODO: this will be the view of the dealer at the top of the screen. There are several different images it will pull from, depending on the phase of the game
        //It needs to be the exact same size and position in each view, to give the illusion of animation.
        switch gameSessionManager.phase
        {
            case .lobby:
                Image("DefaultPlaceholder")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .ignoresSafeArea()
            case .collectingData:
                Image("ThinkingPlaceholder")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .ignoresSafeArea()
            case .calculating:
                //TODO: create shuffle animation by swapping between shuffleA and shuffleB images in regular time intervals
                Image("ShuffleBPlaceholder")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .ignoresSafeArea()
            case .results:
                //TODO: create dealing animation by swapping between shuffleA and dealing images in regular time intervals
                Image("DealingPlaceholder")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .ignoresSafeArea()
        }
    }
}

#Preview
{
    DealerView()
        .environment(GameSessionManager())
}
