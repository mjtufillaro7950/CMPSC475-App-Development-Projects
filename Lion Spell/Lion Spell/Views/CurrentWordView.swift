//
//  CurrentWordView.swift
//  Lion Spell
//
//  Created by Michael Tufillaro on 1/25/26.
//

import SwiftUI

struct CurrentWordView: View
{
    var body: some View
    {
        VStack
        {
            Text("Current Word")
                .font(.headline)
            ZStack
            {
                
                RoundedRectangle(cornerRadius: 16)
                    .frame(height: 75)
                    .foregroundColor(.cyan)
                Text("Current Word Goes Here!")
            }
            Text("Feedback for current word goes here")
                .font(.caption)
        }
    }
}

#Preview {
    MainView()
}
