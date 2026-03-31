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
        //create tabs to access the 3 different views
        TabView
        {
            Tab("List", systemImage: "list.bullet")
            {
                ListView()
            }
            Tab("Types", systemImage: "square.split.2x2.fill")
            {
                TypesView()
            }
            Tab("Account", systemImage: "person.crop.circle.fill")
            {
                AccountView()
            }
        }
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
