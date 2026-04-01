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
    
    //need state variables for search/filter stuff
    //current text in search bar
    @State private var searchText: String = ""
    //all the pokemon types selected by the user in the filter
    @State private var selectedTypes: Set<PokemonType> = []
    //same for capture status
    @State private var showCapturedOnly: Bool = false
    //computed property to get the list of filtered pokemon
    var filteredPokemon: [Pokemon]
    {
        return networkManager.currentPokemonList.filter
        {
            //filter by search bar...
            $0.name.localizedCaseInsensitiveContains(searchText) &&
            //and filter by type...
            $0.types.contains(where: { selectedTypes.contains($0) }) &&
            //and filter by capture status
            (!showCapturedOnly || $0.captured)
        }
    }
    
    var body: some View
    {
        VStack
        {
            //TODO: Filter stuff here
            Text("Pokédex")
                .font(.largeTitle)
                .bold()
            
            SearchBarView(searchText: $searchText)
            
            ScrollView
            {
                //Create a view for each pokemon
                //TODO: will need to replace this with the list after filter criteria
                ForEach(networkManager.currentPokemonList)
                {
                    pokemon in
                    
                    //link to that pokemon's detailed view when tapped on
                    NavigationLink(destination: PokemonDetailView(pokemonID: pokemon.id))
                    {
                        //Show the pokemon's view
                        PokemonListViewDisplay(pokemon: pokemon)
                    }
                    
                }
                //when the list appears, call network manager to update the current list of pokemon
                .task{try? await networkManager.updateCurrentPokemon()}
            }
        }
        
    }
}


struct SearchBarView: View
{
    @Binding var searchText: String
    var body: some View
    {
        ZStack
        {
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(.regularMaterial)
                .frame(height: 40)
            //connect the text in the seach bar to the state variable
            HStack
            {
                Image(systemName: "magnifyingglass")
                TextField("Search Pokémon", text: $searchText)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}


//Display the pokemon and its stats
struct PokemonListViewDisplay: View
{
    let pokemon: Pokemon
    var body: some View
    {
        //TODO: replace with custom pretty view
        Text("\(pokemon.name)")
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
