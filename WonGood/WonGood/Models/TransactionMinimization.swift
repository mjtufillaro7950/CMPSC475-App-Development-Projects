//
//  TransactionMinimization.swift
//  WonGood
//
//  Created by Michael Tufillaro on 4/13/26.
//

import Foundation
import MultipeerConnectivity
import SwiftUI


//func that takes a list of Players, and returns the minimized list of Transactions needed to account for everything
func transactionMinimization(playerList: [Player]) -> [Transaction]
{
    //simulate a heap by creating a list of all players with a positive balance, sorted by largest balance owed
    var positiveHeap = playerList
        .filter{ $0.balance > 0 }
        .sorted{ abs($0.balance) > abs($1.balance) }
    
    //same thing but for negative balances and sorted by largest balance due
    var negativeHeap = playerList
        .filter{ $0.balance < 0 }
        .sorted{ abs($0.balance) > abs($1.balance) }
    
    var transactionList: [Transaction] = []
    
    //helper functions that add and re-sort values to the two heaps
    func addPlayerToPositiveHeap(_ player: Player)
    {
        positiveHeap.append(player)
        positiveHeap.sort{ abs($0.balance) > abs($1.balance) }
    }
    
    func addPlayerToNegativeHeap(_ player: Player)
    {
        negativeHeap.append(player)
        negativeHeap.sort{ abs($0.balance) > abs($1.balance) }
    }
    
    //loop until at least one of the heaps is empty
    while !positiveHeap.isEmpty && !negativeHeap.isEmpty
    {
        //pop the largest values from both heaps
        var creditor = positiveHeap.removeFirst()
        var debtor = negativeHeap.removeFirst()
        //the transaction amount is whichever balance is lower
        let transactionAmount: Double = min(abs(creditor.balance), abs(debtor.balance))
        //create a Transaction and add it to the list
        transactionList.append(Transaction(id: UUID(), debtor: debtor, creditor: creditor, balance: transactionAmount))
        
        //if the creditor is owed more than the debtor can pay
        if abs(creditor.balance) > abs(debtor.balance)
        {
            //update the creditors balance and add it back into the heap, discarding the debtor
            creditor.balance -= transactionAmount
            addPlayerToPositiveHeap(creditor)
            
        }
        
        //if the debtor owes more than the creditor needs
        else if abs(creditor.balance) < abs(debtor.balance)
        {
            //update the debtors balance and add it back into the heap, discarding the creditor
            debtor.balance += transactionAmount
            addPlayerToNegativeHeap(debtor)
        }
        
        //if their balances are the same, neither needs to be added back into the heap so do nothing
    }
    
    //if both heaps are empty, then everything has been settled so just return the list of transactions
    if positiveHeap.isEmpty && negativeHeap.isEmpty
    {
        return transactionList
    }
    
    //if one heap still has value(s) in it, then there must be a user error because poker is a zero-sum game. Alert user.
    else
    {
        //TODO: will eventually need to account for incorrect/leftover balances, but idk if that should go here or in the prior views
        return []
    }
}


