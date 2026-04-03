//
//  AccountView.swift
//  Pokedex
//
//  Created by Michael Tufillaro on 3/30/26.
//

import SwiftUI

//Creates the Account page to see email and log out
struct AccountView: View
{
    @Environment(NetworkManager.self) private var networkManager
    @Environment(AuthManager.self) private var authManager
    
    var body: some View
    {
        VStack(alignment: .leading)
        {
            Text("Account")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(.black)
                .padding(.leading)
            
            ZStack
            {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(.white)
                    .frame(height: 50)
                RoundedRectangle(cornerRadius: 15)
                    .stroke(lineWidth: 3)
                    .frame(height: 50)
                HStack
                {
                    //if the email exists, display it
                    if let email = authManager.userEmail
                    {
                        Text("Email:")
                        Spacer()
                        Text("\(email)")
                    }
                    else
                    {
                        Text("No email found")
                    }
                }
                .bold()
                .foregroundStyle(.black)
                .padding(.horizontal)
            }
        }
        .padding()
        
        //log out button that resets authorization
        Button
        {
            authManager.resetAuthState()
        }
        label:
        {
            ZStack
            {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(.red)
                    .frame(width: 125, height: 40)
                HStack
                {
                    Image(systemName: "arrowshape.turn.up.left.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                    Text("Log Out")
                        .bold()
                }
                .foregroundStyle(.white)
            }
        }
        Spacer()
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
