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
        //call this to handle the animation of the dealing
        DealingTableView(transactions: gameSessionManager.resolvedTransactions)
        
        //TODO: make a dedicated sheet for plain-text transactions
        HStack
        {
            //button to pull up sheet of plain text transactions
            Button
            {
                showTransactionSheet = true
            }
            label:
            {
                ZStack
                {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(Color.titleColor)
                        .frame(width: 150, height: 40)
                    HStack
                    {
                        Image(systemName: "list.bullet.rectangle")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                        Text("Transactions")
                            .bold()
                    }
                    .foregroundStyle(.white)
                }
            }
            
            Button
            {
                gameSessionManager.leaveGame()
            }
            label:
            {
                ZStack
                {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(Color.titleColor)
                        .frame(width: 150, height: 40)
                    HStack
                    {
                        Image(systemName: "arrowshape.turn.up.left.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                        Text("Leave Room")
                            .bold()
                    }
                    .foregroundStyle(.white)
                }
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
