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
    
    //TODO: make this look nice
    var body: some View
    {
        VStack
        {
            Text("Account")
            HStack
            {
                if let email = authManager.userEmail
                {
                    Text("Email: \(email)")
                }
                
            }
            Button("Log Out")
            {
                authManager.resetAuthState()
            }
            .foregroundStyle(.red)
        }
        .padding()
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
