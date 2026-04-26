//
//  CardView.swift
//  WonGood
//
//  Created by Michael Tufillaro on 4/21/26.
//

import SwiftUI

struct PlayerCardView: View
{
    //pass in the size of the card and the player its for
    let cardWidth: CGFloat
    let player: Player
    
    var body: some View
    {
        //make a layout struct to calculate the necessary size of the different views
        let layout = CardLayout(cardWidth: cardWidth)
        
        ZStack
        {
            //border of card
            RoundedRectangle(cornerRadius: layout.cardCornerRadius)
                .stroke(lineWidth: layout.cardStrokeWidth)
            
            //subtle background gradient of card with a shadow
            RoundedRectangle(cornerRadius: layout.cardCornerRadius)
                .foregroundStyle(layout.cardGradient)
                .shadow(radius: layout.shadowRadius)
            
            HStack
            {
                //add the corner design in the top left of card
                VStack
                {
                    CardCornerDesign(cardWidth: cardWidth, player: player)
                    Spacer()
                }
                
                Spacer()
                PlayerMiddleText(cardWidth: cardWidth, player: player, layout: layout)
                Spacer()
                
                //same corner design, upside down and on the bottom right
                VStack
                {
                    Spacer()
                    CardCornerDesign(cardWidth: cardWidth, player: player)
                        .rotationEffect(.degrees(180))
                }
            }
            .padding(layout.paddingSize)
        }
        .frame(width: cardWidth, height: layout.cardHeight)
    }
}

//similar to the player card but makes a card for a transaction instead
struct TransactionCardView: View
{
    //pass in the size of the card and the transaction its for
    let cardWidth: CGFloat
    let transaction: Transaction
    
    var body: some View
    {
        //make a layout struct to calculate the necessary size of the different views
        let layout = CardLayout(cardWidth: cardWidth)
        
        ZStack
        {
            //border of card
            RoundedRectangle(cornerRadius: layout.cardCornerRadius)
                .stroke(lineWidth: layout.cardStrokeWidth)
            
            //subtle background gradient of card with a shadow
            RoundedRectangle(cornerRadius: layout.cardCornerRadius)
                .foregroundStyle(layout.cardGradient)
                .shadow(radius: layout.shadowRadius)
            
            HStack
            {
                //the debtors card info is in top left, and the creditor's name is in the top right
                VStack
                {
                    CardCornerDesign(cardWidth: cardWidth, player: transaction.debtor)
                    Spacer()
                }
                
                Spacer()
                //TODO: middle text needs to be colored with a gradient of the two players
                TransactionMiddleText(cardWidth: cardWidth, transaction: transaction, layout: layout)
                Spacer()
                
                //the creditor's card info is in bottom right, and the debtor's name in bottom left
                VStack
                {
                    Spacer()
                    CardCornerDesign(cardWidth: cardWidth, player: transaction.creditor)
                        .rotationEffect(.degrees(180))
                }
            }
            .padding(layout.paddingSize)
        }
        .frame(width: cardWidth, height: layout.cardHeight)
    }
}


struct PlayerMiddleText: View
{
    //pass in the size of the card and the player its for
    let cardWidth: CGFloat
    let player: Player
    let layout: CardLayout
    //return + if positive balance or - if negative
    var symbol: String
    {
        return player.balance >= 0 ? "plus.rectangle": "minus.rectangle.fill"
    }
    
    var body: some View
    {
        ZStack
        {
            //border of card
            RoundedRectangle(cornerRadius: layout.cardCornerRadius)
                .stroke(lineWidth: layout.cardStrokeWidth / 4)
                .frame(height: layout.cardHeight * 0.75)
            //gradient from debtor's color to creditor
                .foregroundStyle(player.cardCustomizationOptions.color.color)
            
            VStack(spacing: cardWidth * 0.01)
            {
                Text(player.name)
                //handles long names
                    .minimumScaleFactor(0.5)
                    .lineLimit(2)
                //truncate to two decimal places
                Image(systemName: symbol)
                Text("$\(String(format: "%.2f", abs(player.balance)))")
                .minimumScaleFactor(0.5)
                .lineLimit(2)
            }
            .padding(.horizontal, layout.paddingSize)
            .bold()
            .font(.system(size: cardWidth * 0.15, design: .serif))
            .foregroundStyle(player.cardCustomizationOptions.color.color)
        }
    }
}

struct TransactionMiddleText: View
{
    //pass in the size of the card and the player its for
    let cardWidth: CGFloat
    let transaction: Transaction
    let layout: CardLayout
    
    var body: some View
    {
        let debtorColor = transaction.debtor.cardCustomizationOptions.color.color
        let creditorColor = transaction.creditor.cardCustomizationOptions.color.color
        
        let maxTransactionNameSize = cardWidth * 0.2
        
        ZStack
        {
            //border of card
            RoundedRectangle(cornerRadius: layout.cardCornerRadius)
                .stroke(lineWidth: layout.cardStrokeWidth / 4)
                .frame(height: layout.cardHeight * 0.75)
                //gradient from debtor's color to creditor
                .foregroundStyle(LinearGradient(
                    gradient: Gradient(colors: [debtorColor, creditorColor]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                    )
                )
            
            VStack(spacing: cardWidth * 0.01)
            {
                Text(transaction.debtor.name)
                //handles long names by shrinking it down and going on two lines if they do not fit
                    .minimumScaleFactor(0.5)
                    .lineLimit(2)
                    .foregroundStyle(debtorColor)
                    .bold()
                    .font(.system(size: maxTransactionNameSize, design: .serif))
                
                Image(systemName: "arrow.down.square.fill")
                    .font(.system(size: cardWidth * 0.2, design: .serif))
                    //gradient from debtor's color to creditor
                    .foregroundStyle(LinearGradient(
                        gradient: Gradient(colors: [debtorColor, creditorColor]),
                        startPoint: .top,
                        endPoint: .bottom
                        )
                    )
                
                Text(transaction.creditor.name)
                //handles long values by shrinking it down and going on two lines if they do not fit
                    .minimumScaleFactor(0.5)
                    .lineLimit(2)
                    .foregroundStyle(creditorColor)
                    .bold()
                    .font(.system(size: maxTransactionNameSize, design: .serif))
                
                
                Text("$\(String(format: "%.2f", abs(transaction.balance)))")
                //handles long values by shrinking it down and going on two lines if they do not fit
                    .minimumScaleFactor(0.5)
                    .lineLimit(2)
                    .foregroundStyle(creditorColor)
                    .bold()
                    .font(.system(size: cardWidth * 0.2, design: .serif))
            }
            .padding(.horizontal, layout.paddingSize)
        }
    }
}


//makes the symbol in the top left/bottom right corner
struct CardCornerDesign: View
{
    //pass in the size of the card and the player its for
    let cardWidth: CGFloat
    let player: Player
    
    //computed properties that pull the relevant customizaton values out of the player object
    var playerValue: String
    {
        return player.cardCustomizationOptions.value.rawValue
    }
    
    var playerSuit: String
    {
        return player.cardCustomizationOptions.suit.imageName
    }
    
    var playerColor: Color
    {
        return player.cardCustomizationOptions.color.color
    }
    
    
    var body: some View
    {
        VStack(spacing: cardWidth * 0.01)
        {
            //add the player's selected value and suit
            Text(playerValue)
                .bold()
                .font(.system(size: cardWidth * 0.2, design: .serif))
            Image(systemName: playerSuit)
                .resizable()
                .frame(width: cardWidth * 0.13, height: cardWidth * 0.13)
        }
        //set the symbols to the player's selected color
        .foregroundStyle(playerColor)
    }
}


#Preview
{
    let cardWidthSmall: CGFloat = 150
    //let cardWidthLarge: CGFloat = 300
    
    let creditor = Player(
        id: UUID(),
        name: "Michael",
        balance: 50.00,
        cardCustomizationOptions: CardCustomizationOptions()
    )
    
    let debtor = Player(
        id: UUID(),
        name: "James",
        balance: -50.00,
        cardCustomizationOptions: CardCustomizationOptions(color: CardColor.red, value: CardValue.ace, suit: CardSuit.hearts)
    )
    
    let previewTransaction: Transaction = Transaction(id: UUID(), debtor: debtor, creditor: creditor, balance: 50)
    
    VStack
    {
        HStack
        {

            PlayerCardView(cardWidth: cardWidthSmall, player: debtor)
            Spacer()
            PlayerCardView(cardWidth: cardWidthSmall, player: creditor)
            
        }
        //TransactionCardView(cardWidth: cardWidthLarge, transaction: previewTransaction)
        TransactionCardView(cardWidth: cardWidthSmall, transaction: previewTransaction)
    }
    .padding()
    .background(Color.tableColor)
    //.ignoresSafeArea()
    
}
