//
//  CardCustomizationView.swift
//  WonGood
//
//  Created by Michael Tufillaro on 4/13/26.
//

import SwiftUI

struct CardCustomizationView: View
{
    @Binding var showCustomizationSheet: Bool
    //declare to access the viewmodel
    @Environment(GameSessionManager.self) var gameSessionManager
    
    @State private var name: String = ""
    
    @State private var balanceText: String = ""
    @State private var nameText: String = ""
    
    @State private var tempPlayer = Player(
            id: UUID(),
            name: "Enter Name",
            balance: 0.0,
            cardCustomizationOptions: CardCustomizationOptions()
        )
    
    var body: some View
    {
        let cardWidth: CGFloat = 200
        
        VStack
        {
            Text("Placeholder data entry view")
            
            Spacer()
            PlayerCardView(cardWidth: cardWidth, player: tempPlayer)
            Spacer()
            
            //TODO: make adjusting these values adjust localplayer
            //TODO: adjust submitBalance to not need to pass in values anymore (because localPlayer is already there)
            //TODO: allow editing of customization options
            
            Text("Enter Info")
                .font(.title)
                .bold()
            
            TextField("Name", text: $nameText)
                .textFieldStyle(.roundedBorder)
                .onChange(of: nameText)
                { _, text in
                    //only updates it if its a double
                    if text != ""
                    {
                        tempPlayer.name = text
                    }
                    //otherwise, default to "Enter Name"
                    else
                    {
                        tempPlayer.name = "Enter Name"
                    }
                }
            
            //TODO: make a positive/negative button to left so can use decmal pad keyboard entry
            TextField("Balance as a positive or negative float", text: $balanceText)
                .textFieldStyle(.roundedBorder)
                //.keyboardType(.decimalPad)
                //when this is changed, attempts to update the temp player's balance
                .onChange(of: balanceText)
                { _, newValue in
                    //only updates it if its a double
                    if let balance = Double(newValue)
                    {
                        tempPlayer.balance = balance
                    }
                    //otherwise, default to 0
                    else
                    {
                        tempPlayer.balance = 0
                    }
                }
            
            //make pickers for the different card customization options
            Picker("Color", selection: $tempPlayer.cardCustomizationOptions.color)
            {
                ForEach(CardColor.allCases, id: \.self)
                { color in
                    Text(color.rawValue.capitalized)
                        .tag(color)
                }
            }
            .pickerStyle(.menu)

            Picker("Value", selection: $tempPlayer.cardCustomizationOptions.value)
            {
                ForEach(CardValue.allCases, id: \.self)
                { value in
                    //get the case names from the enum
                    Text(String(describing: value).capitalized)
                        .tag(value)
                }
            }

            Picker("Suit", selection: $tempPlayer.cardCustomizationOptions.suit)
            {
                ForEach(CardSuit.allCases, id: \.self)
                { suit in
                    Text(suit.rawValue.capitalized)
                        .tag(suit)
                }
            }
            //.pickerStyle(.segmented)
            
            
            Button("Submit Changes")
            {
                //submit the name and balance
                gameSessionManager.submitBalance(name: name, amount: Double(balanceText)!)
                //close the sheet when submit is pressed
                showCustomizationSheet = false
            }
            //ensure the button can only be hit when both text fields are filled and valid
            //TODO: for finished product, make it only work with a max of 2 decimals
            .disabled(nameText.isEmpty || Double(balanceText) == nil)
            Spacer()
        }
        .padding()
    }
}

#Preview
{
    @Previewable @State var showCustomizationSheet: Bool = true
    @Previewable @State var manager = GameSessionManager()
        
    CardCustomizationView(showCustomizationSheet: $showCustomizationSheet)
        .environment(manager)
        .onAppear
        {
            manager.localPlayer = Player(
                id: UUID(),
                name: "Michael",
                balance: 50.00,
                cardCustomizationOptions: CardCustomizationOptions()
            )
        }
}
