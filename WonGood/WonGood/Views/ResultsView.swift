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
    @State private var showTransactionSheet: Bool = false
    var body: some View
    {
        //call this to handle the view of the cards being dealt with animation
        DealingTableView(transactions: gameSessionManager.resolvedTransactions)
        
        HStack
        {
            //button to pull up sheet of plain text transactions
            Button
            {
                showTransactionSheet = true
            }
            label:
            {
                GenericButtonLabel(buttonText: "Transactions", systemImageName: "list.bullet.rectangle")
            }
            
            //button to leave game
            Button
            {
                gameSessionManager.leaveGame()
            }
            label:
            {
                GenericButtonLabel(buttonText: "Leave Room", systemImageName: "arrowshape.turn.up.left.fill")
            }
        }
        .sheet(isPresented: $showTransactionSheet)
        {
            TransactionsListView()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        Spacer()
    }
}

#Preview
{
    ResultsView()
        .environment(GameSessionManager())
}
