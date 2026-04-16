//
//  ResultsView.swift
//  WonGood
//
//  Created by Michael Tufillaro on 4/13/26.
//

import SwiftUI

struct ResultsView: View
{
    //declare to access the viewmodel
    @Environment(GameSessionManager.self) var gameSessionManager
    
    var body: some View
    {
        //TODO: this is gonna be the animated one. one at a time, cards are "dealt" out, highlighting the transactions pertinent to the user. Tapping on one brings it to the front.
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview
{
    ResultsView()
        .environment(GameSessionManager())
}
