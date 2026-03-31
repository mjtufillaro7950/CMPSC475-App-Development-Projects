//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by LiasPub on 3/30/26.
//

import SwiftUI

struct PokemonDetailView: View
{
    //TODO: figure out image stuff- make this refreshable in case images don't show up?
    let pokemon: Pokemon
    var body: some View
    {
        Text("I choose you: \(pokemon.name)!")
    }
}

#Preview
{

    let authManager = AuthManager()
    let networkManager = NetworkManager()
    networkManager.configure(with: authManager)
    
    //displays the standard Pokemon (Bulbasaur) for testing purposes
    return PokemonDetailView(pokemon: Pokemon.standard)
        .environment(authManager)
        .environment(networkManager)
}
