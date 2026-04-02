//
//  TypesView.swift
//  Pokedex
//
//  Created by Michael Tufillaro on 3/30/26.
//

import SwiftUI

struct TypesView: View
{
    @Environment(NetworkManager.self) private var networkManager
    @Environment(AuthManager.self) private var authManager
    
    //get list of all captured pokemon
    var capturedPokemon: [Pokemon]
    {
        return networkManager.currentPokemonList.filter { $0.captured }
    }
    
    var body: some View
    {
        ScrollView(.vertical)
        {
            VStack(alignment: .leading)
            {
                Text("Types")
                    .font(.largeTitle)
                    .bold()
                //if there are any captured pokemon, display them
                if !capturedPokemon.isEmpty
                {
                    CapturedPokemonView(capturedPokemon: capturedPokemon)
                }
                
                //for each type, generate a card for each pokemon
                ForEach(PokemonType.allCases)
                {
                    type in
                    //get all pokemon with the current type
                    let pokemonByType = networkManager.currentPokemonList.filter {$0.types.contains(type)}
                    PokemonByTypeView(pokemonByType: pokemonByType, type: type)
                    
                }
            }
            //attempt to update the list of current pokemon whenever this view appears
            .task{try? await networkManager.updateCurrentPokemon()}
            //add the ability to scroll up to refresh
            .refreshable { try? await networkManager.updateCurrentPokemon() }
            .padding()
        }
    }
}


struct CapturedPokemonView: View
{
    let capturedPokemon: [Pokemon]
    var body: some View
    {
        HStack
        {
            Image("PokemonBall")
                .resizable()
                .scaledToFit()
                .frame(width: 20)
            Text("Captured")
                .bold()
                .font(.title2)
                .padding(.leading)
                .foregroundStyle(.black)
            Text("(\(capturedPokemon.count))")
                .foregroundStyle(.black)
        }
        ScrollView(.horizontal)
        {
            HStack
            {
                ForEach(capturedPokemon)
                {
                    pokemon in
                    //Clicking on the image of the evolution sends you to its page
                    NavigationLink(destination: PokemonDetailView(pokemonID: pokemon.id))
                    {
                        //render the pokemon's image
                        DetailImageBoxWithCaptureIcon(pokemon: pokemon)
                            .frame(width: 140, height: 200)
                    }
                }
            }
        }
        .padding(5)
    }
}


struct PokemonByTypeView: View
{
    let pokemonByType: [Pokemon]
    let type: PokemonType
    
    var body: some View
    {
        HStack
        {
            Image(systemName: "circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 20)
                .foregroundStyle(Color(pokemonType: type))
            
            Text("\(type.rawValue)")
                .bold()
                .font(.title2)
                .padding(.leading)
                .foregroundStyle(.black)
            
            Text("(\(pokemonByType.count))")
                .foregroundStyle(.black)
        }
        ScrollView(.horizontal)
        {
            HStack
            {
                ForEach(pokemonByType)
                {
                    pokemon in
                    //Clicking on the image of the evolution sends you to its page
                    NavigationLink(destination: PokemonDetailView(pokemonID: pokemon.id))
                    {
                        //render the pokemon's image
                        DetailImageBoxWithCaptureIcon(pokemon: pokemon)
                            .frame(width: 140, height: 200)
                    }
                }
            }
        }
        .padding(5)
    }
}


#Preview
{
    let authManager = AuthManager()
    let networkManager = NetworkManager()
    networkManager.configure(with: authManager)
    //displays the standard Pokemon (Bulbasaur) for testing purposes
    return TypesView()
        .environment(authManager)
        .environment(networkManager)
}
