//
//  AuthManager.swift
//  Pokedex
//
//  Created by Nader Alfares on 3/6/26.
//
import Foundation
import SwiftUI


@Observable
class AuthManager {
    //TODO: published properties for authenticated user
    
    //(recommended) use in your views to show an alert for errors
    var errorMessage: String?
    
    //UserDefaults keys
    private let tokenKey = "pokedex_access_token"
    private let userEmailKey = "pokedex_user_email"
    
    init() {
        // immediate login for persisted user credentials
        loadAuthUser()
    }
    
    
    func setUser(email: String, _ token: String) {
        //TODO: set authenticated user's credentials (login)
        saveToken(token)
        saveUserEmail(email)
    }
    
    func resetAuthState() {
        //TODO: reset propeties of AuthManager (logout)
        deleteToken()
        deleteUserEmail()
    }
    
    // MARK: - Private Methods
    // Helper functions for UserDefualts
    private func loadAuthUser() {
        //TODO: load user credentials from UserDefaults
    }
    private func saveToken(_ token: String) {
        //TODO: save token in UserDefualts
    }
    private func deleteToken() {
        //TODO: save token in UserDefualts
    }
    private func saveUserEmail(_ email: String) {
        //TODO: save user email in UserDefualts
    }
    private func deleteUserEmail() {
        //TODO: delete user email in UserDefualts
    }
    
}

