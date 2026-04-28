//
//  ShuffleView.swift
//  WonGood
//
//  Created by Michael Tufillaro on 4/14/26.
//

import SwiftUI

struct ShuffleView: View
{
    @Environment(GameSessionManager.self) var gameSessionManager
    
    var body: some View
    {
        //TODO: put in the random "dealer quote" here
        //TODO: make it be the same quote on all connected screens? would need to broadcast this then :sob:
        Text("Placeholder Shuffle View")
        Spacer()
    }
}

#Preview
{
    @Previewable @State var manager = GameSessionManager()
    MainView()
        .environment(manager)
        .onAppear
        {
            manager.phase = .shuffle
        }
}
