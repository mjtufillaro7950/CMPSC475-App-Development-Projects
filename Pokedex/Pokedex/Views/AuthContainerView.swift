//
//  AuthContainerView.swift
//  Pokedex
//
//  Created by Michael Tufillaro on 3/30/26.
//

import SwiftUI

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
    //AuthContainerView()
}
