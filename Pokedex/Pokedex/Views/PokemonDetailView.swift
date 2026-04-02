//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by Michael Tufillaro on 3/30/26.
//

import SwiftUI

struct PokemonDetailView: View
{
    //TODO: figure out image stuff- make this refreshable in case images don't show up?
    //Need following stuff:
        //Image, name, and id# on a background corresponding to their type
        //Button that captures or releases depending on its captured status
        //Its types, colored its special color
        //Stats screen for its height and weight
        //List of its type weaknesses, again colored by type
        //List of any next and/or previous evolutions (same mini thing as in Types list)
    //                DetailImageBox(pokemon: TODO: for each pokemons next or prev evolutions)
    //                    .frame(width: 140, height: 200)
    let pokemonID: Int
    
    //fetches the pokemon from the list of currentPokemon given the id
    var pokemon: Pokemon?
    {
        if let pokemon = networkManager.currentPokemonList.first(where: { $0.id == pokemonID })
        {
            return pokemon
        }
        return nil
    }
    
    @Environment(NetworkManager.self) private var networkManager
    @Environment(AuthManager.self) private var authManager
    var body: some View
    {
        //scrolling view containing all elements of the detail page
        ScrollView
        {
            //tries to fetch the current pokemon, otherwise goes to ProgressView
            if let pokemon = pokemon
            {
                VStack()
                {
                    Text("I choose you: \(pokemon.name)!")
                        .bold()
                        .font(.title)
                        .foregroundStyle(.black)
                    DetailImageBoxWithCaptureIcon(pokemon: pokemon)
                        .frame(height: 250)
                    CaptureButton(pokemon: pokemon)
                    TypeIndicators(pokemon: pokemon, indicator: Indicator.selfTypes)
                    StatsView(pokemon: pokemon)
                    WeaknessesView(pokemon: pokemon)
                    //display evolutions, if there are any
                    if (pokemon.next_evolution != nil) || (pokemon.prev_evolution != nil)
                    {
                        EvolutionsView(pokemon: pokemon)
                    }
                }
            }
            else
            {
                ProgressView()
            }
        }
        .padding()
        //need to update the list of current pokemon whenever it appears
        .task{try? await networkManager.updateCurrentPokemon()}
    }
}


//Creates the box that contains the pokemon's image, name, and ID
struct DetailImageBox: View
{
    let pokemon: Pokemon
    var body: some View
    {
        ZStack
        {
            RoundedRectangle(cornerRadius: 15)
                //creates a Linear Gradient using the pokemon's type colors
                .foregroundStyle(LinearGradient(pokemon: pokemon))
            VStack()
            {
                //Add the pokemon's image, fetched from the server
                PokemonImage(pokemon: pokemon)
                    //.frame(width: 140, height: 140)
                //Add the Pokemon's name and ID
                Text("\(pokemon.name)")
                    .bold()
                    .foregroundStyle(.white)
                    .font(.title)
                    //these shrink the text if it doesn't fit on one line
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                //Adds the id number with leading 0s if necessary
                Text("#\(String(format: "%03d", pokemon.id))")
                    .foregroundStyle(.white)
            }
            .padding()
        }
    }
}


//basically the same thing but add a small icon to the top right if the current pokemon has been captured
struct DetailImageBoxWithCaptureIcon: View
{
    let pokemon: Pokemon
    var body: some View
    {
        ZStack(alignment: .topTrailing)
        {
            DetailImageBox(pokemon: pokemon)
            
            //if the pokemon has been captured, add a pokeball icon in the top right
            if pokemon.captured
            {
                Image("PokemonBall")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                    .padding(5)
            }
        }
    }
}


//return the pokemon's image, or a question mark if its not found
struct PokemonImage: View
{
    let pokemon: Pokemon
    var body: some View
    {
        //finds and returns the image of the pokemon
        AsyncImage(url: NetworkManager.getImageURL(for: pokemon.id))
        {
            image in
            image
                .resizable()
                .scaledToFit()
        }
        //adds a default question mark as the placeholder
        placeholder:
        {
            Image(systemName: "questionmark.circle")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.white)
                .opacity(0.7)
        }
    }
}


//define the button that inverts the current pokemon's capture status

struct CaptureButton: View
{
    let pokemon: Pokemon
    @Environment(NetworkManager.self) private var networkManager
    @Environment(AuthManager.self) private var authManager
    //computed properties that find the text/color of the capture button depending on if the pokemon is captured or not
    var buttonText: String
    {
        return pokemon.captured ? "Release": "Capture"
    }
    var buttonColor: Color
    {
        return pokemon.captured ? .red: .green
    }
    
    var body: some View
    {
        Button
        {
            //This updates the capture status
            //need to contain this in a Task because its an async call
            Task
            {
                do
                {
                    //triggers the networkManager to change the capture status
                    try await networkManager.setCapture(for: pokemon.id, isCaptured: !pokemon.captured)
                    //update the current list of pokemon to reflect change in capture status in real time
                    try await networkManager.updateCurrentPokemon()
                }
                catch
                {
                    print("\(error)")
                }
            }
        }
        label:
        {
            ZStack
            {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(buttonColor)
                    .frame(height: 50)
                HStack
                {
                    Image("PokemonBall")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                    
                    Text("\(buttonText)")
                        .foregroundStyle(.white)
                        .font(.title2.bold())
                }
            }
        }
    }
}


//helper enum that determines which type of type to read from
enum Indicator
{
    case selfTypes, weaknessTypes
    
    var id: Self { self }
}


//return an Hstack of each of the pokemon's types
struct TypeIndicators: View
{
    let pokemon: Pokemon
    let indicator: Indicator
    //returns either the list of a pokemon's types or its weaknesses
    var typeList: [PokemonType]
    {
        switch indicator
        {
            case .selfTypes:
                return pokemon.types
            case .weaknessTypes:
                return pokemon.weaknesses
        }
    }
    
    var body: some View
    {
        //make a view for each type in the list
        HStack
        {
            ForEach(typeList)
            {
                type in
                ZStack
                {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(pokemonType: type))
                        .frame(width: 80, height: 25)
                    HStack
                    {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 7)
                            .foregroundStyle(.white)
                        Text("\(type.rawValue.capitalized)")
                            .font(.caption)
                            .bold()
                            .foregroundStyle(.white)
                    }
                    
                }
            }
        }
    }
}


struct StatsView: View
{
    let pokemon: Pokemon
    var body: some View
    {
        ZStack
        {
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(.white)
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.black, lineWidth: 3)
            
            VStack
            {
                Spacer()
                
                HStack
                {
                    Image(systemName: "chart.bar")
                    Text("Stats")
                }
                .bold()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(10)
                
                Spacer()
                
                //list height and weight here
                HStack
                {
                    Spacer()
                    Image(systemName: "ruler")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.blue)
                        .frame(width: 30)
                    
                    VStack
                    {
                        Text("HEIGHT:")
                            .font(.body)
                        Text("\(String(format: "%.1f", pokemon.height))m")
                            .font(.title2)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "square.stack.3d.up")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.orange)
                        .frame(width: 30)
                    
                    VStack
                    {
                        Text("WEIGHT:")
                            .font(.body)
                        Text("\(String(format: "%.1f", pokemon.weight))kg")
                            .font(.title2)
                    }
                    Spacer()
                }
                .bold()
                Spacer()
            }
        }
        .padding(2)
    }
}


struct WeaknessesView: View
{
    let pokemon: Pokemon
    var body: some View
    {
        ZStack
        {
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(.white)
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.black, lineWidth: 3)
            VStack
            {
                Spacer()
                HStack
                {
                    Image(systemName: "exclamationmark.shield")
                    Text("Weaknesses")
                }
                .bold()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(10)
                Spacer()
                ScrollView(.horizontal)
                {
                    TypeIndicators(pokemon: pokemon, indicator: Indicator.weaknessTypes)
                }
                .padding(.horizontal)
                Spacer()
            }
        }
        .padding(2)
    }
}


struct EvolutionsView: View
{
    let pokemon: Pokemon
    @Environment(NetworkManager.self) private var networkManager
    @Environment(AuthManager.self) private var authManager
    
    var body: some View
    {
        ZStack
        {
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(.white)
                .frame(height: 100)
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.black, lineWidth: 3)
            
            VStack
            {
                
                HStack
                {
                    Image(systemName: "arrow.branch")
                    Text("Evolutions")
                }
                .bold()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(10)
                
                //list the detail view images of the evolutions here
                VStack(alignment: .leading)
                {
                    //Makes view for any previous evolutions
                    if let prevEvolutions = pokemon.prev_evolution
                    {
                        Text("Previous")
                            .bold()
                            .font(.title2)
                            .padding(.leading)
                        ScrollView(.horizontal)
                        {
                            HStack
                            {
                                ForEach(prevEvolutions, id: \.self)
                                {
                                    evolutionID in
                                    //get the pokemon from the currentPokemonlist with the same ID
                                    if let prevPokemon = networkManager.currentPokemonList.first(where: { $0.id == evolutionID })
                                    {
                                        
                                        //Clicking on the image of the evolution sends you to its page
                                        NavigationLink(destination: PokemonDetailView(pokemonID: prevPokemon.id))
                                        {
                                            //render the pokemon's image
                                            DetailImageBoxWithCaptureIcon(pokemon: prevPokemon)
                                                .frame(width: 140, height: 200)
                                        }
                                        
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding()
                    }
                    
                    
                    //does same for next evolutions
                    if let nextEvolutions = pokemon.next_evolution
                    {
                        Text("Next")
                            .bold()
                            .font(.title2)
                            .padding(.leading)
                        ScrollView(.horizontal)
                        {
                            HStack
                            {
                                ForEach(nextEvolutions, id: \.self)
                                {
                                    evolutionID in
                                    //get the pokemon from the currentPokemonlist with the same ID
                                    if let nextPokemon = networkManager.currentPokemonList.first(where: { $0.id == evolutionID })
                                    {
                                        //Clicking on the image of the evolution sends you to its page
                                        NavigationLink(destination: PokemonDetailView(pokemonID: nextPokemon.id))
                                        {
                                            //render the pokemon's image
                                            DetailImageBoxWithCaptureIcon(pokemon: nextPokemon)
                                                .frame(width: 140, height: 200)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding()
                    }
                    Spacer()
                }
            }
        }
        .padding(2)
    }
}



#Preview
{

    let authManager = AuthManager()
    let networkManager = NetworkManager()
    networkManager.configure(with: authManager)
    //displays the standard Pokemon (Bulbasaur) for testing purposes
    return PokemonDetailView(pokemonID: Pokemon.standard.id)
        .environment(authManager)
        .environment(networkManager)
    
}
