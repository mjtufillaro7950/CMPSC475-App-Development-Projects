//
//  ModelStructs.swift
//  WonGood
//
//  Created by Michael Tufillaro on 4/13/26.
//

import Foundation

//TODO: replace this 
//struct that represents a player and their associated balance
struct Player
{
    let name: String
    var balance: Double
}

//struct that represents a necessary transaction between players
struct Transaction
{
    let debtorName: String
    let creditorName: String
    var balance: Double
}
