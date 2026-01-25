//
//  ContentView.swift
//  Lion Spell
//
//  Created by LiasPub on 1/24/26.
//

import SwiftUI
import Foundation

struct ContentView: View
{
    //assigns the number of letters given
    let numLetters = 5
    var body: some View
    {
        VStack
        {
            HStack
            {
                Text("Lion Spell")
                Spacer()
                VStack
                {
                    Text("Score")
                        .font(.footnote)
                    ZStack
                    {
                        RoundedRectangle(cornerRadius: 16)
                            .frame(width: 70, height: 50)
                            .foregroundColor(.cyan)
                        Text("0")
                            .font(.title)
                    }
                    
                }
            }
            Text("Build your word/Current Word")
            RoundedRectangle(cornerRadius: 16)
                .frame(height: 50)
                .foregroundColor(.cyan)
            Text("Scrollable list of found words")
            ZStack
            {
                RoundedRectangle(cornerRadius: 16)
                    .frame(height: 50)
                    .foregroundColor(.cyan)
                ScrollView(.horizontal)
                {
                    HStack
                    {
                        ForEach(1...20, id: \.self)
                        {index in
                            Text("Word \(index)")
                        }
                    }
                }
                .padding()
            }
            Text("5 different letters")
            HStack
            {
                ForEach(1...numLetters, id: \.self)
                {
                    index in
                    //this checks to see if the index is the middle one, and if so, makes the middle box yellow
                    if index == Int(ceil(Double(numLetters)/2))
                    {
                        RoundedRectangle(cornerRadius: 16)
                            .frame(width: 50, height: 70)
                            .foregroundColor(.yellow)
                    }
                    else
                    {
                        RoundedRectangle(cornerRadius: 16)
                            .frame(width: 50, height: 70)
                            .foregroundColor(.cyan)
                    }
                }
            }
            
            HStack
            {
                ZStack
                {
                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: 70, height: 50)
                        .foregroundColor(.red)
                    Text("Delete")
                }
                
                ZStack
                {
                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: 70, height: 50)
                        .foregroundColor(.green)
                    Text("Enter")
                }
            }
            Spacer()
            HStack
            {
                ZStack
                {
                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: 70, height: 50)
                        .foregroundColor(.green)
                    Text("Shuffle")
                }
                Spacer()
                ZStack
                {
                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: 70, height: 50)
                        .foregroundColor(.red)
                    Text("Restart")
                }
            }
        }
        .padding()
        .background(Color.blue)
    }
}

#Preview
{
    ContentView()
}
