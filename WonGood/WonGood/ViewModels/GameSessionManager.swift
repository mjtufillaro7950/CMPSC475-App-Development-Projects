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
    //computed property for room view
    var needsPlayerInfo: Bool { localPlayer == nil }
    
    //vars used for Multipeer Connectivity stuff
    private let myPeerID = MCPeerID(displayName: UIDevice.current.name)
    private var hostPeerID: MCPeerID?
    private var session: MCSession!
    private var advertiser: MCNearbyServiceAdvertiser?
    private var browser: MCNearbyServiceBrowser?
    private let serviceType = "wongood-game"
    
    
    //make a custom init, building off of the NSObject framework which is required for MCConnectivity delegation
    override init()
    {
        super.init()
        //make a new MCSession, and make self the sessions delegate
        self.session = MCSession(
            peer: self.myPeerID,
            securityIdentity: nil,
            encryptionPreference: .required
        )
        self.session.delegate = self
    }
    
    
    //start advertising so other devices can find the host device
    func hostGame()
    {
        self.isHost = true
        self.advertiser = MCNearbyServiceAdvertiser(
            peer: self.myPeerID,
            discoveryInfo: nil,
            serviceType: self.serviceType
        )
        self.advertiser?.delegate = self
        self.advertiser?.startAdvertisingPeer()
    }
    
    
    //stop advertising and run minimiztion algorithm
    func lockAndCalculate()
    {
        self.advertiser?.stopAdvertisingPeer()
        self.phase = .calculating
        //change everyone else's phase to calculating (no data needed so empty value)
        self.broadcast(type: .startCalculation, payload: Data())
        //run the minimization algorithm and store/encode the results
        let transactions = transactionMinimization(playerList: players)
        guard let encodedTransactions = try? JSONEncoder().encode(transactions) else { return }
        self.resolvedTransactions = transactions
        self.phase = .results
        //TODO: if i want to have a dedicated shuffling animation, I will need some way to halt this until whatever animation is done
        //send the results to everyone
        broadcast(type: .distributeResults, payload: encodedTransactions)
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
        //update peer id and join
        self.hostPeerID = hostPeerID
        browser?.invitePeer(hostPeerID, to: session, withContext: nil, timeout: 30)
    }
    
    
    //update the player's info
//    func updatePlayerInfo(name: String, amount: Double)
//    {
//        let player = Player(id: UUID(), name: name, balance: amount)
//        self.localPlayer = player
//    }
    
    //send player information to host
    func submitBalance(name: String, amount: Double)
    {
        //TODO: I'm eventually going to need to add an extra parameter for card customization options
        //create a player object for the local player
        let player = Player(id: UUID(), name: name, balance: amount)
        self.localPlayer = player
        //TODO: if editing later, this might add people twice, so maybe check and remove duplicates before adding to list?
        //the host doesn't need to broadcast so just add to the list of players and make sure its updated
        if self.isHost
        {
            // Add directly — can't broadcast to yourself
            players.append(player)
            // Then re-broadcast the updated list to clients
            guard let encoded = try? JSONEncoder().encode(players) else { return }
            broadcast(type: .syncPlayerList, payload: encoded)
        }
        //send player information to host
        else
        {
            guard let encoded = try? JSONEncoder().encode(player) else { return }
            broadcast(type: .playerSubmit, payload: encoded)
        }
    }
    
    
    //send info across connected devices
    private func broadcast(type: MessageType, payload: Data)
    {
        //make a message using the type and data
        let message = GameMessage(type: type, payload: payload)
        //make sure the message can be encoded and there's at least one connected peer
        guard
            let data = try? JSONEncoder().encode(message), !session.connectedPeers.isEmpty
        else { return }
        //send the information to peers
        try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
    }
    
    
    //run whenever recieving a message from a peer
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID)
    {
        //try to decode the message
        guard let message = try? JSONDecoder().decode(GameMessage.self, from: data) else { return }
        DispatchQueue.main.async
        {
            //depending on the message's type, handle it differently
            switch message.type
            {
                
                //add a player to the list of players when they join the room/create a card
                case .playerSubmit:
                    guard let player = try? JSONDecoder().decode(Player.self, from: message.payload) else { return }
                    self.players.append(player)
                    
                    //when a player joins, send message to update lists
                    if self.isHost
                    {
                        guard let encoded = try? JSONEncoder().encode(self.players) else { return }
                        self.broadcast(type: .syncPlayerList, payload: encoded)
                    }

                //update list of players
                case .syncPlayerList:
                    guard let updatedPlayers = try? JSONDecoder().decode([Player].self, from: message.payload) else { return }
                    self.players = updatedPlayers
                
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
    
    
    //run when there's a change in connectivity
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState)
    {
        DispatchQueue.main.async
        {
            //whenever someone joins, host needs to update everyone's list of players
            if state == .connected && self.isHost
            {
                guard let encoded = try? JSONEncoder().encode(self.players) else { return }
                self.broadcast(type: .syncPlayerList, payload: encoded)
            }
            
            //if the host disconnects, all players go back to the lobby
            if state == .notConnected && peerID == self.hostPeerID
            {
                self.leaveGame()
            }
        }
    }
    
    //as a byproduct of MCSessionDelegate, I need session funcs for didRecieve stream, and didStart/didFinish ReceivingResourceWithName
    //they're not used and don't do anything but it throws an error unless I have them
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
    
    //leaves the game, resetting all relavent funcs and values
    func leaveGame()
    {
        //disconnect from other players
        session.disconnect()
        
        //stop advertising/browsing
        self.advertiser?.stopAdvertisingPeer()
        self.advertiser = nil
        self.browser?.stopBrowsingForPeers()
        self.browser = nil
        //reset states
        self.players = []
        self.foundHosts = []
        self.isHost = false
        self.phase = .lobby
        self.hostPeerID = nil
        
        //rebuild the session var so it can be used again
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
    }
    
}
