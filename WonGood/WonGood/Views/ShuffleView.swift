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
        //TODO: unused for now, but the idea is to have a little shuffle animation for a second or two before the results come out
        Text("Placeholder Shuffle View")
    }
}

#Preview
{
    ShuffleView()
        .environment(GameSessionManager())
}
