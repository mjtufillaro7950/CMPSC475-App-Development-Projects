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
                //TODO: update this so that it accurately reflects the current running word
                RoundedRectangle(cornerRadius: 16)
                    .frame(height: 75)
                    .foregroundColor(.cyan)
                Text("Current Word Goes Here!")
            }
            //TODO: update feedback as necessary when Enter is clicked
            Text("Feedback for current word goes here")
                .font(.caption)
        }
    }
}

#Preview
{
    MainView()
        .environment(ViewModel())
}
