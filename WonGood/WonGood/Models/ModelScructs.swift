//
//  ModelStructs.swift
//  WonGood
//
//  Created by Michael Tufillaro on 4/13/26.
//

import Foundation
import MultipeerConnectivity


//struct that represents a player and their associated balance
struct Player: Codable, Identifiable
{
    let id: UUID
    var name: String = "Enter Name"
    var balance: Double = 0
    var cardCustomizationOptions: CardCustomizationOptions = CardCustomizationOptions()
}


//struct that represents a transaction between players
struct Transaction: Codable, Identifiable
{
    let id: UUID
    let debtor: Player
    let creditor: Player
    var balance: Double
}


//this controls the different stages of the game loop
enum GamePhase: String, Codable
{
    //choosing between host/join game
    case lobby
    //in the game room
    case room
    //calculating results (shuffling animation?)
    case shuffle
    //display results
    case results
}


//different types of messages that are sent using Multipeer Connectivity
enum MessageType: String, Codable
{
    //peer sends host Player information
    case playerSubmit
    //host tells all peers to move to calculation/shuffle phase
    case startCalculation
    //host tells all peers to display results
    case distributeResults
    //host refreshes all peers player lists
    case syncPlayerList
}


//creates a message to be sent that has both data and a message type so the recipient knows how to interpret it
struct GameMessage: Codable
{
    let type: MessageType
    let payload: Data
}
