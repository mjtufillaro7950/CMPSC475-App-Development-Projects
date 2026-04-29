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
    
    @State private var tempPlayer = Player(id: UUID())
    
    var body: some View
    {
        let cardWidth: CGFloat = 150
        
        //return + if positive balance or - if negative
        var symbol: String
        {
            return tempPlayer.balance >= 0 ? "plus.rectangle": "minus.rectangle.fill"
        }
        
        VStack(spacing: 5)
        {
            
            Text("Enter Info:")
                .font(.title)
                .bold()
                .foregroundStyle(Color.dealerGray)
            
            ZStack
            {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(Color.dealerGray)
                    .frame(height: 50)
                
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.black, lineWidth: 2)
                    .frame(height: 50)
                
                HStack(spacing: 2)
                {
                    Spacer()
                    
                    TextField("Name", text: $nameText)
                        .frame(width: 100)
                        .textFieldStyle(.roundedBorder)
                        .foregroundStyle(Color.titleColor)
                        .onChange(of: nameText)
                        {
                            _, text in
                            //updates any non-blank text
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
                    
                    Spacer()
                    
                    //Button that changes whether the balance entered is positive or negative
                    Button
                    {
                        tempPlayer.balance *= -1
                    }
                    label:
                    {
                        Image(systemName: symbol)
                            .font(.largeTitle)
                            .foregroundStyle(Color.titleColor)
                            .bold()
                    }
                    
                    TextField("Balance", text: $balanceText)
                        .frame(width: 100)
                        .textFieldStyle(.roundedBorder)
                        .foregroundStyle(Color.titleColor)
                    
                        //only implements this if opening on a real device
                        #if !targetEnvironment(simulator)
                        //use decimal pad because a number is being entered
                        .keyboardType(.decimalPad)
                        //when not on a simulator, the decimal pad has no button to dismiss it, so add one
                        .toolbar
                        {
                            ToolbarItemGroup(placement: .keyboard)
                            {
                                Spacer()
                                Button("Done")
                                {
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                }
                            }
                        }
                        #endif
                    
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
                    
                    Spacer()
                }
            }
            .padding(.bottom, 20)
            
            Text("Your card is the... ")
                .font(.title)
                .bold()
                .foregroundStyle(Color.dealerGray)
            
            HStack
            {
                //make pickers for the different card customization options
                Picker("Color", selection: $tempPlayer.cardCustomizationOptions.color)
                {
                    ForEach(CardColor.allCases, id: \.self)
                    { color in
                        Text(color.rawValue.capitalized)
                            .tag(color)
                    }
                }
                .frame(width: 100)
                .tint(Color.titleColor)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.dealerGray))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 2))
                
                Picker("Value", selection: $tempPlayer.cardCustomizationOptions.value)
                {
                    ForEach(CardValue.allCases, id: \.self)
                    { value in
                        //get the case names from the enum
                        Text(String(describing: value).capitalized)
                            .tag(value)
                    }
                }
                .frame(width: 95)
                .tint(Color.titleColor)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.dealerGray))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 2))
                
                Text("of")
                    .foregroundStyle(Color.dealerGray)
                    .bold()
                    .font(.title3)
                
                Picker("Suit", selection: $tempPlayer.cardCustomizationOptions.suit)
                {
                    ForEach(CardSuit.allCases, id: \.self)
                    { suit in
                        Text(suit.rawValue.capitalized)
                            .tag(suit)
                    }
                }
                .frame(width: 120)
                .tint(Color.titleColor)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.dealerGray))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 2))
            }
            .padding(.bottom, 20)
            
            Button
            {
                //submit the name and balance
                gameSessionManager.submitPlayer(player: tempPlayer)
                //close the sheet when submit is pressed
                showCustomizationSheet = false
            }
            label:
            {
                ZStack
                {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(Color.titleColor)
                        .frame(width: 150, height: 40)
                    HStack
                    {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                        Text("Add Player")
                            .bold()
                    }
                    .foregroundStyle(.white)
                }
            }
            //ensure the button can only be hit when both text fields are filled and valid
            //transparent when inactive
            .opacity(nameText.isEmpty || Double(balanceText) == nil || Double(balanceText) == 0 ? 0.4: 1)
            .disabled(nameText.isEmpty || Double(balanceText) == nil || Double(balanceText) == 0)
            .padding(.bottom, 50)
            
            PlayerCardView(cardWidth: cardWidth, player: tempPlayer)

        }
        .padding()
        .background(Color.screenColor)
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
