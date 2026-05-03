//
//  GenericButtonLabel.swift
//  WonGood
//
//  Created by MichaelTufillaro on 5/3/26.
//

import SwiftUI

//make a consistent button design used across views
struct GenericButtonLabel: View
{
    //pass in the text and image name
    let buttonText: String
    let systemImageName: String
    
    var body: some View
    {
        ZStack
        {
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(Color.titleColor)
                .frame(width: 150, height: 40)
            HStack
            {
                Image(systemName: systemImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
                Text(buttonText)
                    .bold()
            }
            .foregroundStyle(.white)
        }
    }
}

#Preview
{
    GenericButtonLabel(buttonText: "Button", systemImageName: "burn")
}
