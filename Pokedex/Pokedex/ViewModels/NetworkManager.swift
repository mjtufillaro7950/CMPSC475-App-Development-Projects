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
    
    func configure(with authManager: AuthManager) {
        //provide access to authManager singlton (single source of truth)
        self.authManager = authManager
    }
    
    func login() async throws {
        //TODO: Implement API request for user login
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
    
}



