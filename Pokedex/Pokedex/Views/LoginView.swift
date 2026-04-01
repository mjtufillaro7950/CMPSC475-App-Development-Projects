//
//  LoginView.swift
//  Pokedex
//
//  Created by Michael Tufillaro on 3/30/26.
//

import SwiftUI

//this code is adapted from the in-class repository
struct LoginView: View
{
    @Environment(NetworkManager.self) private var networkManager
    @Environment(AuthManager.self) private var authManager
    
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showSignup = false
    
    var body: some View
    {
        NavigationStack
        {
            ZStack
            {
                // Background
                LinearGradient(
                    colors: [Color.red, Color.white],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30)
                {
                    Spacer()
                    
                    // Logo/Title
                    VStack(spacing: 10)
                    {
                        Image("PokemonBall")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150)
                        
                        Text("Pokedex")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundStyle(.black)
                    }
                    
                    
                    // Login Form
                    VStack(spacing: 20)
                    {
                        // Email Field
                        VStack(alignment: .leading, spacing: 8)
                        {
                            Text("Email:")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.black)
                            
                            TextField("", text: $email)
                                .textFieldStyle(AuthTextFieldStyle())
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                                .autocorrectionDisabled()
                        }
                        
                        // Password Field
                        VStack(alignment: .leading, spacing: 8)
                        {
                            Text("Password:")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.black)
                            
                            SecureField("", text: $password)
                                .textFieldStyle(AuthTextFieldStyle())
                        }
                        
                        // Login Button
                        Button(action: login)
                        {
                            HStack
                            {
                                if isLoading
                                {
                                    ProgressView()
                                        .tint(.blue)
                                }
                                else
                                {
                                    Text("Log In")
                                        .fontWeight(.semibold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(.white)
                            .foregroundStyle(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .disabled(isLoading || email.isEmpty || password.isEmpty)
                        
                        // Sign Up Link
                        Button
                        {
                            showSignup = true
                        }
                        label:
                        {
                            HStack(spacing: 4)
                            {
                                Text("Don't have an account?")
                                    .foregroundStyle(.black.opacity(0.9))
                                Text("Sign Up")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.blue)
                            }
                            .font(.subheadline)
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                }
            }
            .alert("Error", isPresented: $showError)
            {
                Button("OK") { showError = false }
            }
            message:
            {
                Text(errorMessage)
            }
            .sheet(isPresented: $showSignup)
            {
                SignupView()
            }
        }
    }
    
    // MARK: - Actions
    private func login()
    {
        Task
        {
            do
            {
                //network manager handles login stuff
                try await networkManager.login(email: email, password: password)
            }
            catch
            {
                //Show the error if it fails
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }
}

// MARK: - Custom Text Field Style

struct AuthTextFieldStyle: TextFieldStyle
{
    func _body(configuration: TextField<Self._Label>) -> some View
    {
        configuration
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview
{
    let authManager = AuthManager()
    let networkManager = NetworkManager()
    networkManager.configure(with: authManager)
    
    return LoginView()
        .environment(authManager)
        .environment(networkManager)
}
