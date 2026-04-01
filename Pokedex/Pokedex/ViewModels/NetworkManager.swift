//
//  NetworkManager.swift
//  Pokedex
//
//  Created by Nader Alfares on 3/6/26.
//
import Foundation
import SwiftUI


@Observable
class NetworkManager
{
    static let ipAddress : String = "http://localhost:8000"
    private var authManager: AuthManager?
    //creates a list of all the current pokemon objects
    var currentPokemonList: [Pokemon] = []
    
    func configure(with authManager: AuthManager)
    {
        //provide access to authManager singlton (single source of truth)
        self.authManager = authManager
    }
    
    
    //Implement API request for user login
    //pretty much all of the code in NetworkManager is taken from class code in Taskly with some modifications
    func login(email: String, password: String) async throws
    {
        //fetches the right url for the Swagger website using the network managers ip address (need to do NetworkManager.ipAddress because it's not static)
        guard let url = URL(string: "\(NetworkManager.ipAddress)/auth/login") else
        {
            throw NetworkError.invalidURL
        }
        //use passed in data to create the payload
        let payload = LoginRequest(email: email, password: password)
        
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
        //instead of returning the tokenResponse, set User in authmanager
        authManager?.setUser(email: tokenResponse.user.email, token: tokenResponse.accessToken)
    }
    
    //add signup code which is the same as login but with a different url
    func signup(email: String, password: String) async throws
    {
        //uses signup url instead of login
        guard let url = URL(string: "\(NetworkManager.ipAddress)/auth/signup") else
        {
            throw NetworkError.invalidURL
        }
        
        //use passed in data to create the payload
        let payload = LoginRequest(email: email, password: password)
        
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
        
        //email already registered error instead of invalid credentials error
        if httpResponse.statusCode == 401
        {
            throw NetworkError.emailAlreadyRegistered
        }
        
        guard (200...299).contains(httpResponse.statusCode) else
        {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
        
        //attempt to deode the data from the response into a TokenResponse
        let decoder = JSONDecoder()
        let tokenResponse = try decoder.decode(TokenResponse.self, from: data)
        //instead of returning the tokenResponse, set User in authmanager
        authManager?.setUser(email: tokenResponse.user.email, token: tokenResponse.accessToken)
    }
    
    
    //adapted frrom Taskly getTasks()
    func getPokemonCollection() async throws -> [Pokemon]
    {
        //Implement API request to get Pokemon collection
        //mostly the same as login
        guard let url = URL(string: "\(NetworkManager.ipAddress)/pokemon") else
        {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        
        //if there is a token, attatch it to the request
        if let token = authManager?.accessToken
        {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else
        {
            throw NetworkError.invalidResponse
        }
        
        if httpResponse.statusCode == 401
        {
            throw NetworkError.unauthorized
        }
        
        guard (200...299).contains(httpResponse.statusCode) else
        {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        //decode the data into an array of Pokemon objects and return it
        return try decoder.decode([Pokemon].self, from: data)
    }
    
    
    //helper function that updates the list of current pokemon
    func updateCurrentPokemon() async throws
    {
        self.currentPokemonList = try await getPokemonCollection()
    }

    
    func getPokemon(id: Int) async throws -> Pokemon
    {
        //Implement API request to get a specific Pokemon by their id
        //pretty much the same as the above function except it goes to a different url and returns a single Pokemon object
        guard let url = URL(string: "\(NetworkManager.ipAddress)/pokemon/\(id)") else
        {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        
        //if there is a token, attatch it to the request
        if let token = authManager?.accessToken
        {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else
        {
            throw NetworkError.invalidResponse
        }
        if httpResponse.statusCode == 401
        {
            throw NetworkError.unauthorized
        }
        
        guard (200...299).contains(httpResponse.statusCode) else
        {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        //decode the data into a Pokemon object and return it
        return try decoder.decode(Pokemon.self, from: data)
    }
    
    
    static func getImageURL(for pokemonId: Int) -> URL?
    {
        // use this URL in AsyncImage
        //this said "pokemons" but I'm pretty sure it needs to be "pokemon" singular
        return URL(string: "\(ipAddress)/pokemon/\(pokemonId)/image")
    }
    
    
    func setCapture(for pokemonId: Int, isCaptured: Bool) async throws
    {
        //implement capture/release of Pokemon using API endpoints pokemon/{id}/capture and pokemon/{id}/release
        //depending on isCaptured, change the endpoint of the URL
        let capturedEndpoint = isCaptured ? "capture" : "release"
        
        //set up the URL to the right endpoint
        guard let url = URL(string: "\(NetworkManager.ipAddress)/pokemon/\(pokemonId)/\(capturedEndpoint)") else
        {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        
        //need to use PUT for capture/release
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        
        //if there is a token, attatch it to the request
        if let token = authManager?.accessToken
        {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        //data isn't used so it is ignored
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else
        {
            throw NetworkError.invalidResponse
        }
        
        if httpResponse.statusCode == 401
        {
            throw NetworkError.unauthorized
        }
        
        guard (200...299).contains(httpResponse.statusCode) else
        {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
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



