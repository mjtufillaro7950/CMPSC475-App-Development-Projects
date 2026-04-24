//
//  DealerView.swift
//  WonGood
//
//  Created by Michael Tufillaro on 4/14/26.
//

import SwiftUI
//in order to animate the shuffling with Timer, need to import combine
import Combine

struct DealerView: View
{
    @Environment(GameSessionManager.self) var gameSessionManager
    
    var body: some View
    {
        //the view of the dealer at the top of the screen. There are several different images it will pull from, depending on the phase of the game
        //It needs to be the exact same size and position in each view, to give the illusion of animation.
        //the final non-placeholder images will all be the exact same size
        ZStack
        {
            //overlay the dealer and the background
            Image("Background")
            
            switch gameSessionManager.phase
            {
            case .lobby:
                Image("Default")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .ignoresSafeArea()
            case .room:
                Image("Thinking")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .ignoresSafeArea()
            case .shuffle:
                //animate card shuffling
                ImageAnimation(firstImage: "ShuffleA", secondImage: "ShuffleB")
            case .results:
                //animate card dealing
                ImageAnimation(firstImage: "ShuffleA", secondImage: "Dealing")
            }
        }
    }
}


//create simple animation by swapping between two images in regular time intervals
struct ImageAnimation: View
{
    let firstImage: String
    let secondImage: String
    @Environment(GameSessionManager.self) var gameSessionManager
    @State private var showFirstImage = true
    
    //creates a timer that triggers every 0.5 seconds
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View
    {
        Image(showFirstImage ? firstImage : secondImage)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .ignoresSafeArea()
            //swaps which image is shown every 5 seconds
            .onReceive(timer)
            { _ in
                showFirstImage.toggle()
            }
            //stops the timer loop when the view is not being shown
            .onDisappear
            {
                timer.upstream.connect().cancel()
            }
    }
}


#Preview
{
    DealerView()
    //ImageAnimation(firstImage: "ShuffleA", secondImage: "Dealing")
        .environment(GameSessionManager())
}
