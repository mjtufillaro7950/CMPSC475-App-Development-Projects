//
//  DealingTableView.swift
//  WonGood
//
//  Created by Michael Tufillaro on 4/27/26.
//

import SwiftUI

//handles the card-dealing animation: cards fly out from the dealer's hand,
//pause large in the center, then shrink and land in a fanned row at the bottom.
//tapping a landed card brings it back to the front, tapping it again returns it.
//TODO: make it so dealer's hand follows actions on screen instead of just oscillating forever
struct DealingTableView: View
{
    let transactions: [Transaction]
    
    //how many cards have completed their deal animation
    @State private var dealtCount: Int = 0
    //the card index currently mid-animation (nil between cards)
    @State private var currentlyDealingIndex: Int? = nil
    @State private var dealingStage: DealingStage = .atDealer
    //the card the user has tapped to bring forward (nil when nothing is showcased)
    @State private var selectedID: UUID? = nil
    //holds the dealing task so it can be cancelled if the view goes away
    @State private var dealTask: Task<Void, Never>? = nil
    
    //which stage of the deal the currently dealing card is in
    enum DealingStage
    {
        case atDealer, showcase, landing
    }
    
    //controls the width of the cards to pass into cardview
    private let cardWidthOnTable: CGFloat = 80
    private let cardWidthShowcase: CGFloat = 220
    
    var body: some View
    {
        //need a geometry reader to position cards within view
        GeometryReader
        {
            geo in
            ZStack
            {
                //add a black background when a card is brought to the front
                //TODO: figure out how to get this to cover the whole thing
                if selectedID != nil
                {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture
                    {
                        withAnimation(.spring(duration: 0.4))
                        { selectedID = nil }
                    }
                }
                
                //show each transaction with animation- use enumerated to get index for each
                ForEach(Array(transactions.enumerated()), id: \.element.id)
                {
                    index, transaction in
                    
                    TransactionCardView(
                        //get current width from helper func
                        cardWidth: widthCalc(index: index, transaction: transaction),
                        transaction: transaction
                    )
                    //determine these values with helper funcs
                    .position(positionCalc(index: index, transaction: transaction, geometry: geo))
                    .opacity(opacityCalc(index: index))
                    .zIndex(zIndexCalc(index: index, transaction: transaction))
                    //tap gesture to bring card up to front
                    .onTapGesture
                    {
                        //only tap cards when done dealing
                        guard index < dealtCount, currentlyDealingIndex == nil else { return }
                        withAnimation(.spring(duration: 0.4))
                        {
                            //bring card up if there's not one up already, or bring it back down if there is one already
                            selectedID = (selectedID == transaction.id) ? nil : transaction.id
                        }
                    }
                }
            }
            //start dealing when the view appears and stop when it disappears
            .onAppear { startDealing() }
            .onDisappear
            {
                dealTask?.cancel()
                dealTask = nil
            }
        }
    }
    
    
    //sequence dealing task
    private func startDealing()
    {
        //don't restart if dealing is already in progress or finished
        guard dealtCount == 0, currentlyDealingIndex == nil else { return }
        
        dealTask = Task
        {
            let count = transactions.count
            //loop through each transaction
            for index in 0..<count
            {
                if Task.isCancelled { return }
                
                //card appears at the dealer
                await MainActor.run
                {
                    currentlyDealingIndex = index
                    dealingStage = .atDealer
                }
                try? await Task.sleep(for: .milliseconds(150))
                if Task.isCancelled { return }
                
                //card moves to center and gets big
                await MainActor.run
                {
                    withAnimation(.easeOut(duration: 0.5))
                    { dealingStage = .showcase }
                }
                try? await Task.sleep(for: .milliseconds(900))
                if Task.isCancelled { return }
                
                //card shrinks and lands in its slot on the table
                await MainActor.run
                {
                    withAnimation(.easeIn(duration: 0.45))
                    { dealingStage = .landing }
                }
                try? await Task.sleep(for: .milliseconds(450))
                if Task.isCancelled { return }
                
                //finish animating
                await MainActor.run
                {
                    dealtCount = index + 1
                    currentlyDealingIndex = nil
                }
                try? await Task.sleep(for: .milliseconds(150))
            }
        }
    }
    
    
    //helper funcs to find visual state
    private func positionCalc(index: Int, transaction: Transaction, geometry: GeometryProxy) -> CGPoint
    {
        //tapped/showcased card sits in the center
        if selectedID == transaction.id
        {
            return CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
        
        //currently animating
        if currentlyDealingIndex == index
        {
            switch dealingStage
            {
            case .atDealer:
                //top edge of the dealing area, just below the dealer's hand
                return CGPoint(x: geometry.size.width / 2, y: 0)
            case .showcase:
                //middle of screen
                return CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            case .landing:
                //call helper to get the position on the table
                return tableSlot(index: index, geometry: geometry)
            }
        }
        
        //already dealt
        if index < dealtCount
        {
            return tableSlot(index: index, geometry: geometry)
        }
        
        //not yet dealt, so stay hidden on top of screen
        return CGPoint(x: geometry.size.width / 2, y: 0)
    }
    
    // resting position for a given card index, cards overlap a bit for a fanned-out look
    private func tableSlot(index: Int, geometry: GeometryProxy) -> CGPoint
    {
        //prevents / 0 error
        let count = max(transactions.count, 1)
        let spacing: CGFloat = cardWidthOnTable * 0.6
        let totalWidth = CGFloat(count - 1) * spacing
        let startX = (geometry.size.width - totalWidth) / 2
        let cardHeightOnTable = cardWidthOnTable * 1.4
        return CGPoint(
            x: startX + CGFloat(index) * spacing,
            //add some extra room on bottom for leave room button
            y: geometry.size.height - cardHeightOnTable / 2 - 10
        )
    }
    
    //width is large when the card is selected or in the showcase stage of dealing, otherwise small
    private func widthCalc(index: Int, transaction: Transaction) -> CGFloat
    {
        if selectedID == transaction.id { return cardWidthShowcase }
        if currentlyDealingIndex == index && dealingStage == .showcase { return cardWidthShowcase }
        return cardWidthOnTable
    }
    
    //hide cards that haven't been dealt yet
    private func opacityCalc(index: Int) -> Double
    {
        if currentlyDealingIndex == index { return 1 }
        if index < dealtCount { return 1 }
        return 0
    }
    
    //make newer cards/inspected cards sit on top of the older ones in the ZStack
    private func zIndexCalc(index: Int, transaction: Transaction) -> Double
    {
        //return a high number for these
        if selectedID == transaction.id { return 100 }
        if currentlyDealingIndex == index { return 99 }
        return Double(index)
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
