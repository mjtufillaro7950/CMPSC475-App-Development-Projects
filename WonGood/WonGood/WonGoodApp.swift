//
//  WonGoodApp.swift
//  WonGood
//
//  Created by LiasPub on 4/13/26.
//

import SwiftUI

@main
struct WonGoodApp: App
{
    @State var gameSessionManager = GameSessionManager()
    var body: some Scene
    {
        WindowGroup
        {
            MainView()
                .environment(gameSessionManager)
        }
    }
}
