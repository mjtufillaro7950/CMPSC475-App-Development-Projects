//
//  ButtonsView.swift
//  Lion Spell
//
//  Created by Michael Tufillaro on 1/25/26.
//

import SwiftUI

struct ButtonsView: View
{
    var body: some View
    {
        HStack
        {
            RegButton(text: "Delete", color: .red)
                .padding(.trailing, 50)
            RegButton(text: "Enter", color: .green)
        }
        Spacer()
        HStack
        {
            RegButton(text: "Shuffle", color: .indigo)
            Spacer()
            RegButton(text: "Restart", color: .yellow)
        }
        .padding()
    }
}

#Preview
{
    MainView()
}
