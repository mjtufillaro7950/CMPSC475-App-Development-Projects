//
//  PokemonRowView.swift
//  Pokedex
//
//  Created by Michael Tufillaro on 4/1/26.
//

import SwiftUI


//Display the pokemon and its stats in the format required for the list view
struct PokemonRowView: View
{
    let pokemon: Pokemon
    var body: some View
    {
        ZStack
        {
            //perimeter
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(.white)
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.black, lineWidth: 3)
            
            HStack
            {
                //display image + colored background
                SmallImageAndBackground(pokemon: pokemon)
                    .frame(width: 80, height: 80)
                    .padding(.leading, 10)
                //display stats
                RowNameAndStats(pokemon: pokemon)
                
                Spacer()
                
                VStack
                {
                    Spacer()
                    //show ID with leading 0s if needed
                    Text("#\(String(format: "%03d", pokemon.id))")
                        .bold()
                        .foregroundStyle(.black)
                    Spacer()
                    //display an image of a pokeball if the pokemon is captured
                    Image("PokemonBall")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                        .padding(5)
                        //opacity is 0 unless its captured
                        .opacity(pokemon.captured ? 1: 0)
                    Spacer()
                }
                .padding(.trailing, 10)
            }
        }
        .padding()
        .frame(height: 100)
    }
}


//creates a small pokemon image with type gradient background
struct SmallImageAndBackground: View
{
    let pokemon: Pokemon
    var body: some View
    {
        ZStack
        {
            RoundedRectangle(cornerRadius: 15)
                //creates a Linear Gradient using the pokemon's type colors
                .foregroundStyle(LinearGradient(pokemon: pokemon))
            PokemonImage(pokemon: pokemon)
            .padding(5)
        }
    }
}


//display name and stats
struct RowNameAndStats: View
{
    let pokemon: Pokemon
    var body: some View
    {
        //.leading so its left oriented
        VStack(alignment: .leading)
        {
            Spacer()
            Text("\(pokemon.name)")
                .bold()
                .font(.title2)
                .foregroundStyle(.black)
            Spacer()
            //add pokemon's types
            TypeIndicators(pokemon: pokemon, indicator: Indicator.selfTypes)
            Spacer()
            //add height and weight
            HeightAndWeight(pokemon: pokemon)
            Spacer()
        }
    }
}


struct HeightAndWeight: View
{
    let pokemon: Pokemon
    var body: some View
    {
        //list height and weight here
        HStack
        {
            Image(systemName: "ruler")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.black)
                .frame(width: 15)
            
            Text("\(String(format: "%.1f", pokemon.height))m")
                .font(.caption2)
                .foregroundStyle(.black)
                
            Image(systemName: "square.stack.3d.up")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.black)
                .frame(width: 15)
            
            Text("\(String(format: "%.1f", pokemon.weight))kg")
                .font(.caption2)
                .foregroundStyle(.black)
        }
        .bold()
    }
}

#Preview
{
    PokemonRowView(pokemon: Pokemon.standard)
}
