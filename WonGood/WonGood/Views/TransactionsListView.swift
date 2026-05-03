//
//  TransactionsListView.swift
//  WonGood
//
//  Created by LiasPub on 5/2/26.
//

import SwiftUI

//list of plain text transactions for results sheet
struct TransactionsListView: View
{
    //declare to access the viewmodel
    @Environment(GameSessionManager.self) var gameSessionManager
    
    //build a single string of all transactions, one per line, for copying
    var allTransactionsString: String
    {
        gameSessionManager.resolvedTransactions
            .map
            { transaction in
                let amount = String(format: "%.2f", abs(transaction.balance))
                return "\(transaction.debtor.name) pays \(transaction.creditor.name) $\(amount)"
            }
            .joined(separator: "\n")
    }
    
    
    var body: some View
    {
        ScrollView
        {
            VStack
            {
                Text("Transactions")
                    .font(.title)
                    .bold()
                    .foregroundStyle(Color.dealerGray)
                    .padding(.top)
                
                //button that copies all transactions to clipboard for easy sharing
                Button
                {
                    UIPasteboard.general.string = allTransactionsString
                }
                label:
                {
                    GenericButtonLabel(buttonText: "Copy All", systemImageName: "doc.on.doc.fill")
                }
                
                //make a row for every transaction in the resolved list
                ForEach(gameSessionManager.resolvedTransactions)
                {
                    transaction in
                    TransactionRowView(transaction: transaction)
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.screenColor)
    }
}


//single row in the transactions list
struct TransactionRowView: View
{
    let transaction: Transaction
    
    var body: some View
    {
        let amount = String(format: "%.2f", abs(transaction.balance))
        
        ZStack
        {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color.dealerGray)
            
            Text("\(transaction.debtor.name) pays \(transaction.creditor.name) $\(amount)")
                .font(.title3)
                .bold()
                .foregroundStyle(Color.titleColor)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
                .lineLimit(2)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                //allow long-press to select and copy text
                .textSelection(.enabled)
        }
    }
}

#Preview
{
    @Previewable @State var manager = GameSessionManager()
    
    MainView()
        .environment(manager)
        .onAppear
        {
            let p1 = Player(id: UUID(), name: "Michael", balance: 100, cardCustomizationOptions: CardCustomizationOptions())
            let p2 = Player(id: UUID(), name: "James", balance: -60, cardCustomizationOptions: CardCustomizationOptions(color: .red, value: .ace, suit: .hearts))
            let p3 = Player(id: UUID(), name: "Tufillaro", balance: -40, cardCustomizationOptions: CardCustomizationOptions(color: .blue, value: .king, suit: .diamonds))
            manager.players = [p1, p2, p3]
            manager.resolvedTransactions = [
                Transaction(id: UUID(), debtor: p2, creditor: p1, balance: 60),
                Transaction(id: UUID(), debtor: p3, creditor: p1, balance: 40)
            ]
            manager.phase = .results
        }
}
