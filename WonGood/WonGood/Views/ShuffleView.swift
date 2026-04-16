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
        Text("Shuffle View")
    }
}

#Preview
{
    ShuffleView()
}
