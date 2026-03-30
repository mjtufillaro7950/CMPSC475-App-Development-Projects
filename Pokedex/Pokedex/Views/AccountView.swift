//
//  AccountView.swift
//  Pokedex
//
//  Created by Michael Tufillaro on 3/30/26.
//

import SwiftUI

struct AccountView: View
{
    @Environment(NetworkManager.self) private var networkManager
    @Environment(AuthManager.self) private var authManager
    
    var body: some View
    {
        Text("Account View")
        Button("Log Out")
        {
            authManager.resetAuthState()
        }
    }
}

#Preview
{
    let authManager = AuthManager()
    let networkManager = NetworkManager()
    networkManager.configure(with: authManager)
    
    return AccountView()
        .environment(authManager)
        .environment(networkManager)

}
