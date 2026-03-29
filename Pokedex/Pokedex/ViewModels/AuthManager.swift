//
//  AuthManager.swift
//  Pokedex
//
//  Created by Nader Alfares on 3/6/26.
//  Edited by Michael Tufillaro on 3/28/26
//
import Foundation
import SwiftUI


@Observable
class AuthManager
{
    //published properties for authenticated user
    //AKA can read from outside the class but can't change them
    private(set) var accessToken: String?
    private(set) var userEmail: String?
    private(set) var isAuthenticated: Bool = false
    
    //(recommended) use in your views to show an alert for errors
    //TODO: do I need this?
    var errorMessage: String? = "ERROR! I guess."
    
    //UserDefaults keys
    private let tokenKey = "pokedex_access_token"
    private let userEmailKey = "pokedex_user_email"
    
    init()
    {
        // immediate login for persisted user credentials
        loadAuthUser()
    }
    
    
    func setUser(email: String, token: String)
    {
        //set authenticated user's credentials to parameters
        self.accessToken = token
        self.userEmail = email
        self.isAuthenticated = true
        saveToken(token)
        saveUserEmail(email)
    }
    
    func resetAuthState()
    {
        //reset propeties of AuthManager by setting them to nil/false
        deleteToken()
        deleteUserEmail()
        self.accessToken = nil
        self.userEmail = nil
        self.isAuthenticated = false
    }
    
    // MARK: - Private Methods
    // Helper functions for UserDefualts

    //This checks to see if a user has signed in before, and if they have, automatically signs that user in
    private func loadAuthUser()
    {
        //load user credentials from UserDefaults
        if let token = UserDefaults.standard.string(forKey: tokenKey)
        {
            if let email = UserDefaults.standard.string(forKey: userEmailKey)
            {
                self.accessToken = token
                self.userEmail = email
                self.isAuthenticated = true
            }
        }
    }
    private func saveToken(_ token: String)
    {
        //save token in UserDefualts
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    private func deleteToken()
    {
        //delete token in UserDefualts
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
    private func saveUserEmail(_ email: String)
    {
        //save user email in UserDefualts
        UserDefaults.standard.set(email, forKey: userEmailKey)

    }
    private func deleteUserEmail()
    {
        //delete user email in UserDefualts
        UserDefaults.standard.removeObject(forKey: userEmailKey)
    }
    
}

