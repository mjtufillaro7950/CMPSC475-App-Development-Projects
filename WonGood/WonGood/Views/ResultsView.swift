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
        //TODO: this is gonna be the animated one. one at a time, transactions represented by cards are "dealt" out, moving from the dealer to the middle of the screen. highlight the transactions pertinent to the user. Tapping on one brings it to the front.
        Text("Placeholder Results View")
        Spacer()
        Text("Transactions:")
        ForEach(gameSessionManager.resolvedTransactions)
        {
            transaction in
            Text("\(transaction.debtor.name) pays \(transaction.creditor.name) \(transaction.balance)")
        }
        Button("Leave Room")
        {
            gameSessionManager.leaveGame()
        }
        Spacer()
    }
}

#Preview
{
    ResultsView()
        .environment(GameSessionManager())
}
