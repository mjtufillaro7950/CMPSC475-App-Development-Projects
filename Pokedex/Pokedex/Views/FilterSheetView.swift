//
//  FilterSheetView.swift
//  Pokedex
//
//  Created by LiasPub on 4/1/26.
//

import SwiftUI

//TODO: make a Sheet for the filter stuff
struct FilterSheetView: View
{
    @Environment(NetworkManager.self) private var networkManager
    @Environment(AuthManager.self) private var authManager
    
    @Binding var selectedTypes: Set<PokemonType>
    @Binding var showCapturedOnly: Bool
    var body: some View
    {
            //TODO: make view for Captured and for each type.
            //tapping on captured toggles it and tapping on type adds or removes it from selectedTypes
            //if captured is true or if the type is in selectedTypes, make checkmark have full or no capacity
            VStack
            {
                //Button that resets filter variables
                Button
                {
                    selectedTypes = []
                    showCapturedOnly = false
                }
                label:
                {
                    Text("Clear all filters")
                }
                
                Divider()
                    .frame(width: 200)
                
                //capture filter toggle
                CaptureFilterView(showCapturedOnly: $showCapturedOnly)
                
                Divider()
                    .frame(width: 200)
                
                Text("Filter by type")
                //Make a similar toggle for each pokemon type
                ForEach(PokemonType.allCases)
                {
                    type in
                    TypeFilterView(selectedTypes: $selectedTypes, type: type)
                }
                
            }
            .padding()
    }
}


//creates the view for the "Captured" toggle
struct CaptureFilterView: View
{
    @Binding var showCapturedOnly: Bool
    
    var body: some View
    {
        //swap the parity of show capture status when pressed
        Button
        {
            showCapturedOnly = !showCapturedOnly
        }
        label:
        {
            ZStack
            {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.black, lineWidth: 5)
                    .frame(width: 125, height: 30)
                HStack
                {
                    //hide the checkmark when not selected
                    if showCapturedOnly
                    {
                        Image(systemName: "checkmark")
                    }
                    Text("Captured")
                }
                .foregroundStyle(.black)
                .bold()
            }
            .padding(.horizontal, 3)
        }
    }
}


struct TypeFilterView: View
{
    @Binding var selectedTypes: Set<PokemonType>
    let type: PokemonType
    var body: some View
    {
        //either add or remove the type from the list of selected types
        Button
        {
            if selectedTypes.contains(type)
            {
                selectedTypes.remove(type)
            }
            else
            {
                selectedTypes.insert(type)
            }
        }
        label:
        {
            ZStack
            {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(Color(pokemonType: type))
                    .frame(width: 125, height: 30)
                HStack
                {
                    //hide the checkmark when not selected
                    if selectedTypes.contains(type)
                    {
                        Image(systemName: "checkmark")
                    }
                    Text("\(type.rawValue)")
                }
                .foregroundStyle(.white)
                .bold()
            }
        }
    }
}


#Preview
{
    //all the pokemon types selected by the user in the filter
    @Previewable @State var selectedTypes: Set<PokemonType> = []
    //same for capture status
    @Previewable @State var showCapturedOnly: Bool = false
    let authManager = AuthManager()
    let networkManager = NetworkManager()
    networkManager.configure(with: authManager)
    
    return FilterSheetView(selectedTypes: $selectedTypes, showCapturedOnly: $showCapturedOnly)
        .environment(authManager)
        .environment(networkManager)
}
