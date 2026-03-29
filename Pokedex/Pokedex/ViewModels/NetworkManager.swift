//
//  NetworkManager.swift
//  Pokedex
//
//  Created by Nader Alfares on 3/6/26.
//
import Foundation
import SwiftUI


@Observable
class NetworkManager {
    static let ipAddress : String = "http://localhost:8000"
    private var authManager: AuthManager?
    
    //temporarily store the user's email and password while logging in for the login func
    var loginEmail: String = ""
    var loginPassword: String = ""
    
    func configure(with authManager: AuthManager) {
        //provide access to authManager singlton (single source of truth)
        self.authManager = authManager
    }
    
    
    //Implement API request for user login- largely taken from class code with some modifications
    func login() async throws
    {
        //fetches the right url for the Swagger website using the network managers ip address
        guard let url = URL(string: "\(NetworkManager.ipAddress)/auth/login") else
        {
            throw NetworkError.invalidURL
        }
        
        //use passed in data to create the payload
        //TODO: login didn't have parameters, meaning that the email and password need to be stored in here?
        let payload = LoginRequest(email: self.loginEmail, password: self.loginPassword)
        
        //build a request for a login
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //enode the request as a JSON
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(payload)
        
        //send the request and wait for a response
        let (data, response) = try await URLSession.shared.data(for: request)
        
        //Throw errors if the response is not correct one way or another
        guard let httpResponse = response as? HTTPURLResponse else
        {
            throw NetworkError.invalidResponse
        }
        
        if httpResponse.statusCode == 401
        {
            throw NetworkError.invalidCredentials
        }
        
        guard (200...299).contains(httpResponse.statusCode) else
        {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
        
        //attempt to deode the data from the response into a TokenResponse
        let decoder = JSONDecoder()
        let tokenResponse = try decoder.decode(TokenResponse.self, from: data)
        //instead of returning the tokenResponse, call setUser in AuthManager
        authManager?.setUser(email: tokenResponse.user.email, token: tokenResponse.accessToken)
    }
    
    func getPokemonCollection() async throws -> [Pokemon] {
        //TODO: Implement API request to get Pokemon collection
    }

    func getPokemon(id: Int) async throws -> Pokemon {
        //TODO: Implement API request to get a specific Pokemon by their id
    }
    
    static func getImageURL(for pokemonId: Int) -> URL? {
        // use this URL in AsyncImage
        return URL(string: "\(ipAddress)/pokemons/\(pokemonId)/image")
    }
    
    func setCapture(for pokemonId: Int, isCaptured: Bool) async throws {
        //TODO: implement capture/release of Pokemon using API endpoints pokemon/{id}/capture and pokemon/{id}/release
    }
    
    //NetworkError Enum taken from class code
    enum NetworkError: LocalizedError
    {
        case invalidURL
        case invalidResponse
        case httpError(statusCode: Int)
        case unauthorized
        case invalidCredentials
        case emailAlreadyRegistered
        
        var errorDescription: String?
        {
            switch self
            {
            case .invalidURL:
                return "The URL is invalid."
            case .invalidResponse:
                return "The server response was invalid."
            case .httpError(let statusCode):
                return "Request failed with status code: \(statusCode)"
            case .unauthorized:
                return "You need to log in to access this resource."
            case .invalidCredentials:
                return "Invalid email or password."
            case .emailAlreadyRegistered:
                return "This email is already registered."
            }
        }
    }
    
}



