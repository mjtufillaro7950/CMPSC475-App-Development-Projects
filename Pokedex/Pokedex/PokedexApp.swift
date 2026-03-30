//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Michael Tufillaro on 3/23/26.
//

import SwiftUI

@main
struct PokedexApp: App
{
    @State var authManager = AuthManager()
    @State var networkManager = NetworkManager()
    
    var body: some Scene
    {
        WindowGroup
        {
            AuthContainerView()
                .environment(authManager)
                .environment(networkManager)
                .onAppear
                {
                    networkManager.configure(with: authManager)
                }
        }
    }
}
