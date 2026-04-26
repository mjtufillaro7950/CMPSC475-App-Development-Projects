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
    
    //controls which main view is being shown
    var phase: GamePhase = .lobby
    //current list of players
    var players: [Player] = []
    //stores the list of transactions after algorithm runs
    var resolvedTransactions: [Transaction] = []
    //updates list of hosts that are found while looking for a game
    var foundHosts: [MCPeerID] = []
    var isHost = false
    //this stores the Player object corresponding to the local user
    var localPlayer: Player?
//    //computed property for roomView
//    var needsPlayerInfo: Bool { localPlayer == nil }
    
    //vars used for Multipeer Connectivity stuff
    
    //ID representing this device
    private let myPeerID = MCPeerID(displayName: UIDevice.current.name)
    //ID representing the hosts device
    private var hostPeerID: MCPeerID?
    //the room that the devices connect to
    private var session: MCSession!
    //lets the host reach out to peers to join
    private var advertiser: MCNearbyServiceAdvertiser?
    //helps peers search for nearby host games
    private var browser: MCNearbyServiceBrowser?
    //key so only other wongood games show up
    private let serviceType = "wongood"
    
    
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
        //start the shuffle animation
        self.phase = .shuffle
        //change everyone else's phase to shuffle (no data needed so empty value)
        self.broadcast(type: .startCalculation, payload: Data())
        //run the minimization algorithm and store/encode the results
        let transactions = transactionMinimization(playerList: self.players)
        guard let encodedTransactions = try? JSONEncoder().encode(transactions) else { return }
        
        Task
        {
            //keep shuffling for a few seconds, before moving onto results
            try? await Task.sleep(for: .seconds(2))
            await MainActor.run
            {
                self.resolvedTransactions = transactions
                self.phase = .results
            }
            //start distributing results to all players
            self.broadcast(type: .distributeResults, payload: encodedTransactions)
        }
    }
    
    
    //start looking for hosts
    func joinGame()
    {
        self.isHost = false
        self.browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        self.browser?.delegate = self
        self.browser?.startBrowsingForPeers()
    }
    
    
    //send invitation to host to join
    func connectToHost(_ hostPeerID: MCPeerID)
    {
        //update peer id and join
        self.hostPeerID = hostPeerID
        self.browser?.invitePeer(hostPeerID, to: self.session, withContext: nil, timeout: 30)
    }
    
    
    //update the player's info
//    func updatePlayerInfo(name: String, amount: Double)
//    {
//        let player = Player(id: UUID(), name: name, balance: amount)
//        self.localPlayer = player
//    }
    
    //send player information to host
    func submitPlayer(player: Player)
    {
        //set the local player value to the submitted player
        self.localPlayer = player
        
        //the host doesn't need to broadcast so just add to the list of players and make sure its updated
        if self.isHost
        {
            //update the host's list of players
            self.players.append(player)
            //re-broadcast the updated list to peers
            guard let encoded = try? JSONEncoder().encode(self.players) else { return }
            self.broadcast(type: .syncPlayerList, payload: encoded)
        }
        //send player information to host
        else
        {
            guard let encoded = try? JSONEncoder().encode(player) else { return }
            self.broadcast(type: .playerSubmit, payload: encoded)
        }
    }
    
    
    //send info across connected devices
    private func broadcast(type: MessageType, payload: Data)
    {
        //make a message using the type and data
        let message = GameMessage(type: type, payload: payload)
        //make sure the message can be encoded and there's at least one connected peer
        guard
            let data = try? JSONEncoder().encode(message), !self.session.connectedPeers.isEmpty else { return }
        //send the information to peers
        try? self.session.send(data, toPeers: self.session.connectedPeers, with: .reliable)
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
                
                //set the flag to start calculating/shuffling
                case .startCalculation:
                    self.phase = .shuffle
                
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
    
    
    //add hosts to list of found hosts when they start advertising
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
        self.browser?.stopBrowsingForPeers()
        self.browser = nil
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
        self.session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
        self.session.delegate = self
    }
}
