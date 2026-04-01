//
//  ListView.swift
//  Pokedex
//
//  Created by Michael Tufillaro on 3/30/26.
//

import SwiftUI

struct ListView: View
{
    @Environment(NetworkManager.self) private var networkManager
    @Environment(AuthManager.self) private var authManager
    
    var body: some View
    {
        //TODO: make a list of all pokemon
        VStack
        {
            //TODO: Filter stuff here
            Text("Pokedex")
            //TODO: Search bar here
            ScrollView
            {
                //Create a view for each pokemon
                //TODO: will need to replace this with the list after filter criteria
                ForEach(networkManager.currentPokemonList)
                {
                    pokemon in
                    Text("\(pokemon.name)")
                }
                //when the list appears, call network manager to update the current list of pokemon
                .task{try? await networkManager.updateCurrentPokemon()}
            }
        }
        
    }
}

#Preview
{
    let authManager = AuthManager()
    let networkManager = NetworkManager()
    networkManager.configure(with: authManager)
    
    return ListView()
        .environment(authManager)
        .environment(networkManager)
}
