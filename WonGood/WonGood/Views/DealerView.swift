//
//  DealerView.swift
//  WonGood
//
//  Created by Michael Tufillaro on 4/14/26.
//

import SwiftUI
//in order to animate the shuffling, need to import combine
import Combine

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
                //animate card shuffling
                ImageAnimation(firstImage: "ShuffleAPlaceholder", secondImage: "ShuffleBPlaceholder")
            case .results:
                //animate card dealing
            ImageAnimation(firstImage: "ShuffleAPlaceholder", secondImage: "DealingPlaceholder")
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
            //cancels the timer when the view is not being shown
            .onDisappear
            {
                timer.upstream.connect().cancel()
            }
    }
}


#Preview
{
    //DealerView()
    ImageAnimation(firstImage: "ShuffleAPlaceholder", secondImage: "DealingPlaceholder")
        .environment(GameSessionManager())
}
