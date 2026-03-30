//
//  AuthContainerView.swift
//  Pokedex
//
//  Created by Michael Tufillaro on 3/30/26.
//

import SwiftUI

//this code is adapted from the in-class repository
struct AuthContainerView: View
{
    @Environment(AuthManager.self) private var authManager
    
    var body: some View
    {
        Group
        {
            if authManager.isAuthenticated
            {
                MainView()
            }
            else
            {
                LoginView()
            }
        }
    }
}


#Preview
{
    let authManager = AuthManager()
    let networkManager = NetworkManager()
    networkManager.configure(with: authManager)
    
    return AuthContainerView()
        .environment(authManager)
        .environment(networkManager)
}
