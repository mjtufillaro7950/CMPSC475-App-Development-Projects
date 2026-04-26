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
        Spacer()
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
