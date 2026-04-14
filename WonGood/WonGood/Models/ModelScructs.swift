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
    var name: String
    var balance: Double
    //id for multipeer connectivity
    var peerID: MCPeerID?
    
    //ignore peerID when coding since its not decodable
    enum CodingKeys: String, CodingKey
    {
        case id, name, balance
    }
}


//struct that represents a transaction between players
struct Transaction: Codable, Identifiable
{
    let id: UUID
    let debtorName: String
    let creditorName: String
    var balance: Double
}


//TODO: replace comments when I understand what this does
enum GamePhase: String, Codable
{
    case lobby           // host is advertising, clients are joining
    case collectingData  // everyone enters their name + balance
    case calculating     // host is running the algorithm
    case results         // transactions have been resolved and distributed
}


//TODO: replace comments when I understand what this does
enum MessageType: String, Codable
{
    case playerSubmit      // client → host: name + balance
    case startCalculation  // host → all: balances locked, computing
    case distributeResults // host → all: here are the transactions
    //TODO: necessary?
    //case playerJoined      // host → all: update lobby list
}


//TODO: replace comments when I understand what this does
struct GameMessage: Codable
{
    let type: MessageType
    let payload: Data   // JSON-encoded Player or [Transaction] depending on type
}
