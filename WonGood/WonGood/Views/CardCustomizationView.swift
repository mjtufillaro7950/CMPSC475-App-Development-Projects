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
    
    var body: some View
    {
        VStack
        {
            Text("Placeholder data entry view")
            Spacer()
            Text("Enter Info")
                .font(.title)
                .bold()
            
            TextField("Name", text: $name)
                .textFieldStyle(.roundedBorder)
            
            TextField("Balance as a positive or negative float", text: $balanceText)
                .textFieldStyle(.roundedBorder)
                //.keyboardType(.decimalPad)
            
            Button("Submit")
            {
                gameSessionManager.submitBalance(name: name, amount: Double(balanceText)!)
                //close the sheet when submit is pressed
                showCustomizationSheet = false
            }
            //ensure the button can only be hit when both fields are filled and valid
            //TODO: for finished product, make it only work with a max of 2 decimals
            .disabled(name.isEmpty || Double(balanceText) == nil)
            Spacer()
        }
        .padding()
    }
}

#Preview
{
    @Previewable @State var showCustomizationSheet: Bool = true
    
    CardCustomizationView(showCustomizationSheet: $showCustomizationSheet)
        .environment(GameSessionManager())
}
