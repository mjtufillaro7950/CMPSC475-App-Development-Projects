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
        Text("Placeholder Results View")
        Spacer()
        //TODO: for right now, just do a ForEach for all Transactions in manager.resolvedTransactions
        Text("Transactions:")
        ForEach(gameSessionManager.resolvedTransactions)
        {
            transaction in
            Text("\(transaction.debtorName) pays \(transaction.creditorName) \(transaction.balance)")
        }
        Spacer()
    }
}

#Preview
{
    ResultsView()
        .environment(GameSessionManager())
}
