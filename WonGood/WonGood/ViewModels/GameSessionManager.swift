//
//  GameSessionManager.swift
//  WonGood
//
//  Created by Michael Tufillaro on 4/14/26.
//

import Foundation
import MultipeerConnectivity
import SwiftUI

@Observable
//needs MultipeerConnectivity stuff (as well as NSObject which they depend on)
class GameSessionManager: NSObject, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate
{
    
    //vars used in views
    var phase: GamePhase = .lobby
    var players: [Player] = []
    var resolvedTransactions: [Transaction] = []
    var foundHosts: [MCPeerID] = []
    var isHost = false
    var localPlayer: Player?
    
    //vars used for Multipeer Connectivity stuff
    private let myPeerID = MCPeerID(displayName: UIDevice.current.name)
    private var session: MCSession!
    private var advertiser: MCNearbyServiceAdvertiser?
    private var browser: MCNearbyServiceBrowser?
    private let serviceType = "wongood-game"
    
    
    //make a custom init, building off of the NSObject framework which is required for MCConnectivity delegation
    override init()
    {
        super.init()
        //make a new MCSession, and make self the sessions delegate
        session = MCSession(
            peer: myPeerID,
            securityIdentity: nil,
            encryptionPreference: .required
        )
        session.delegate = self
    }
    
    
    //start advertising so other devices can find the host device
    func hostGame()
    {
        isHost = true
        advertiser = MCNearbyServiceAdvertiser(
            peer: myPeerID,
            discoveryInfo: nil,
            serviceType: serviceType
        )
        advertiser?.delegate = self
        advertiser?.startAdvertisingPeer()
    }
    
    
    //stop advertising and run minimiztion algorithm
    func lockAndCalculate()
    {
        advertiser?.stopAdvertisingPeer()
        phase = .calculating
        broadcast(type: .startCalculation, payload: Data())
        
        let transactions = transactionMinimization(playerList: players)
        guard let encoded = try? JSONEncoder().encode(transactions) else { return }
        resolvedTransactions = transactions
        phase = .results
        broadcast(type: .distributeResults, payload: encoded)
    }
    
    
    //start looking for hosts
    func joinGame()
    {
        isHost = false
        browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        browser?.delegate = self
        browser?.startBrowsingForPeers()
    }
    
    
    //send invitation to host to join
    func connectToHost(_ hostPeerID: MCPeerID)
    {
        browser?.invitePeer(hostPeerID, to: session, withContext: nil, timeout: 30)
    }
    
    
    //send host player information
    func submitBalance(name: String, amount: Double)
    {
        //make a Player object using the name and balance
        let player = Player(id: UUID(), name: name, balance: amount)
        //TODO: what is localPlayer?
        localPlayer = player
        guard let encoded = try? JSONEncoder().encode(player) else { return }
        broadcast(type: .playerSubmit, payload: encoded)
    }
    
    
    //send info across connected devices
    private func broadcast(type: MessageType, payload: Data)
    {
        //make a message using the type and data
        let message = GameMessage(type: type, payload: payload)
        //make sure the message can be encoded and there's at least one connected peer
        guard
            let data = try? JSONEncoder().encode(message),
            !session.connectedPeers.isEmpty
        else { return }
        //send the information to peers
        try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
    }
    
    
    //this func recieves and interprets broadcasted messages
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID)
    {
        //try to decode the message
        guard let message = try? JSONDecoder().decode(GameMessage.self, from: data) else { return }
        DispatchQueue.main.async
        {
            //depending on the message's type, handle it differently
            switch message.type
            {
                
                //add a new player to the list of players
            case .playerSubmit:
                guard let player = try? JSONDecoder().decode(Player.self, from: message.payload) else { return }
                self.players.append(player)
                
                //set the flag to start calculating the transactions
            case .startCalculation:
                self.phase = .calculating
                
                //set the flag to start distributing results
            case .distributeResults:
                //decode and assign the list of transactions
                guard let transactions = try? JSONDecoder().decode([Transaction].self, from: message.payload) else { return }
                self.resolvedTransactions = transactions
                self.phase = .results
                
            }
        }
    }
    
    //as a byproduct of MCSessionDelegate, I need session funcs for didChange, didRecieve stream, and didStart/didFinish ReceivingResourceWithName
    //they're not used and don't do anything but it throws an error unless I have them
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {}
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
    
    
    //calls handler when the host recieves an invitation to join
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void)
    {
        invitationHandler(true, session)
    }
    
    
    //add hosts to list of found hosts when they are start advertising
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?)
    {
        DispatchQueue.main.async { self.foundHosts.append(peerID) }
    }
    
    //remove hosts from list of found hosts when they stop advertising
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID)
    {
        DispatchQueue.main.async { self.foundHosts.removeAll { $0 == peerID } }
    }
    
    //get rid of the current browser when stopping searching for joinable games
    func stopSearching()
    {
        browser?.stopBrowsingForPeers()
        browser = nil
    }
}
