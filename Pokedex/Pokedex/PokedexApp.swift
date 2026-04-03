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
            //start with the auth container view to make sure user is signed in
            AuthContainerView()
                .environment(authManager)
                .environment(networkManager)
                //configure the auth manager and network manager when calling the auth container view
                .onAppear
                {
                    networkManager.configure(with: authManager)
                }
        }
    }
}
