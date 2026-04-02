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
    @State var searchText: String = ""
    //all the pokemon types selected by the user in the filter
    @State var selectedTypes: Set<PokemonType> = []
    //same for capture status
    @State var showCapturedOnly: Bool = false
    //controls whether filter sheet is shown
    @State var showSheet: Bool = false
    
    //computed property to get the list of filtered pokemon
    var filteredPokemon: [Pokemon]
    {
        return networkManager.currentPokemonList.filter
        {
            //filter by search bar...
            (searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText)) &&
            //and filter by type...
            (selectedTypes.isEmpty || $0.types.contains(where: { selectedTypes.contains($0) })) &&
            //and filter by capture status
            (!showCapturedOnly || $0.captured)
        }
    }
    
    var body: some View
    {
        VStack
        {
            Text("Pokédex")
                .font(.largeTitle)
                .bold()
            
            Spacer()
            
            FilterButton(selectedTypes: $selectedTypes, showCapturedOnly: $showCapturedOnly, showSheet: $showSheet)
            
            SearchBarView(searchText: $searchText)
            
            ScrollView
            {
                //Create a view for each pokemon in the filtered list
                ForEach(filteredPokemon)
                {
                    pokemon in
                    
                    //link to that pokemon's detailed view when tapped on
                    NavigationLink(destination: PokemonDetailView(pokemonID: pokemon.id))
                    {
                        //Show the pokemon's view
                        PokemonRowView(pokemon: pokemon)
                    }
                    
                }
                //when the list appears, call network manager to update the current list of pok
                .task{try? await networkManager.updateCurrentPokemon()}
            }
            //add the ability to scroll up to refresh
            .refreshable { try? await networkManager.updateCurrentPokemon() }
        }
        
    }
}


struct FilterButton: View
{
    //all the pokemon types selected by the user in the filter
    @Binding var selectedTypes: Set<PokemonType>
    //same for capture status
    @Binding var showCapturedOnly: Bool
    //controls whether filter sheet is shown
    @Binding var showSheet: Bool
    
    var body: some View
    {
        //Button that pulls up the filter sheet when pressed
        Button
        {
            showSheet = true
        }
        label:
        {
            ZStack
            {
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 110, height: 40)
                    .foregroundStyle(.gray)
                HStack
                {
                    Image(systemName: "gear")
                    Text("Filters")
                }
                .foregroundStyle(.black)
                .bold()
            }
            
        }
        .sheet(isPresented: $showSheet)
        {
            FilterSheetView(selectedTypes: $selectedTypes, showCapturedOnly: $showCapturedOnly)
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


#Preview
{
    let authManager = AuthManager()
    let networkManager = NetworkManager()
    networkManager.configure(with: authManager)
    
    return ListView()
        .environment(authManager)
        .environment(networkManager)
}
