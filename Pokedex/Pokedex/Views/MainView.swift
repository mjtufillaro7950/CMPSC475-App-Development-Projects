//
//  ContentView.swift
//  Pokedex
//
//  Created by Michael Tufillaro on 3/23/26.
//

import SwiftUI

struct MainView: View
{
    @Environment(NetworkManager.self) private var networkManager
    @Environment(AuthManager.self) private var authManager
    var body: some View
    {
        //TODO: need to 
        VStack
        {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Main View")
            //logs the current user out
            Button("Log Out")
            {
                authManager.resetAuthState()
            }
        }
        .padding()
    }
}

#Preview
{
    let authManager = AuthManager()
    let networkManager = NetworkManager()
    networkManager.configure(with: authManager)
    
    return MainView()
        .environment(authManager)
        .environment(networkManager)
}
