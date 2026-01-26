//
//  FoundWordsView.swift
//  Lion Spell
//
//  Created by Michael Tufillaro on 1/25/26.
//

import SwiftUI

struct FoundWordsView: View
{
    var body: some View
    {
        ZStack
        {
            RoundedRectangle(cornerRadius: 16)
                .frame(height: 100)
                .foregroundColor(.cyan)
            VStack
            {
                Text("FOUND WORDS")
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .font(.headline)
                    .bold()
                Spacer()
                ScrollView(.horizontal)
                {
                    HStack
                    {
                        //TODO: replace this with a running list of found words. Possible include their point values and possibly change their color if something like pangram
                        ForEach(1...20, id: \.self)
                        {index in
                            Text("Word \(index)")
                        }
                    }
                }
            }
            .padding()
            .frame(height: 100)
        }
    }
}

#Preview
{
    MainView()
}
