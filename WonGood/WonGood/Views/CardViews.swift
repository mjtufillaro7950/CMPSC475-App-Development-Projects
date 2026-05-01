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
    
    //initially, I rendered each view's size as a function of the passed in card width, but ran into issues when animating a size change, as each view changed size slightly differently, making the animation look disconnected. My fix is to render everything at a fixed size and then shrink the whole view based on the passed in cardWidth
    private static let baseWidth: CGFloat = 250
    
    var body: some View
    {
        //make a layout struct to calculate the necessary size of the different views
        let layout = CardLayout(cardWidth: Self.baseWidth)
        //calculate the scale needed to adjust the card to get to the desired width
        let scale = cardWidth / Self.baseWidth
        
        ZStack
        {
            //border of card
            RoundedRectangle(cornerRadius: layout.cardCornerRadius)
                .stroke(lineWidth: layout.cardStrokeWidth)
                .foregroundStyle(.black)
            
            //subtle background gradient of card with a shadow
            RoundedRectangle(cornerRadius: layout.cardCornerRadius)
                .foregroundStyle(layout.cardGradient)
                .shadow(radius: layout.shadowRadius)
            
            HStack(spacing: 0)
            {
                //add the corner design in the top left of card
                VStack
                {
                    CardCornerDesign(cardWidth: Self.baseWidth, player: player)
                    Spacer()
                }
                .frame(width: layout.sideSpacing)
                
                PlayerMiddleText(cardWidth: Self.baseWidth, player: player, layout: layout)
                
                //same corner design, upside down and on the bottom right
                VStack
                {
                    Spacer()
                    CardCornerDesign(cardWidth: Self.baseWidth, player: player)
                        .rotationEffect(.degrees(180))
                }
                .frame(width: layout.sideSpacing)
            }
            .padding(layout.paddingSize)
        }
        //make the card always render in light mode due to color issues between modes
        .environment(\.colorScheme, .light)
        //first, render the card at the base width and height
        .frame(width: Self.baseWidth, height: layout.cardHeight)
        //then, scale the card so the view is visually the same size as the desired width
        .scaleEffect(scale)
        //finally, reframe the view so the frame matches its new width and height
        .frame(width: cardWidth, height: layout.cardHeight * scale)
    }
}


//similar to the player card but makes a card for a transaction instead
struct TransactionCardView: View
{
    //pass in the size of the card and the transaction its for
    let cardWidth: CGFloat
    let transaction: Transaction
    
    private static let baseWidth: CGFloat = 250
    
    var body: some View
    {
        //make a layout struct to calculate the necessary size of the different views
        let layout = CardLayout(cardWidth: Self.baseWidth)
        //calculate the scale needed to adjust the card to get to the desired width
        let scale = cardWidth / Self.baseWidth
        
        ZStack
        {
            //border of card
            RoundedRectangle(cornerRadius: layout.cardCornerRadius)
                .stroke(lineWidth: layout.cardStrokeWidth)
                .foregroundStyle(.black)
            
            //subtle background gradient of card with a shadow
            RoundedRectangle(cornerRadius: layout.cardCornerRadius)
                .foregroundStyle(layout.cardGradient)
                .shadow(radius: layout.shadowRadius)
            
            HStack(spacing: 0)
            {
                //the debtors card info is in top left, and the creditor's name is in the top right
                VStack
                {
                    CardCornerDesign(cardWidth: Self.baseWidth, player: transaction.debtor)
                    Spacer()
                }
                .frame(width: layout.sideSpacing)
                
                TransactionMiddleText(cardWidth: Self.baseWidth, transaction: transaction, layout: layout)
                
                //the creditor's card info is in bottom right, and the debtor's name in bottom left
                VStack
                {
                    Spacer()
                    CardCornerDesign(cardWidth: Self.baseWidth, player: transaction.creditor)
                        .rotationEffect(.degrees(180))
                }
                .frame(width: layout.sideSpacing)
            }
            .padding(layout.paddingSize)
        }
        .environment(\.colorScheme, .light) 
        //first, render the card at the base width and height
        .frame(width: Self.baseWidth, height: layout.cardHeight)
        //then, scale the card so the view is visually the same size as the desired width
        .scaleEffect(scale)
        //finally, reframe the view so the frame matches its new width and height
        .frame(width: cardWidth, height: layout.cardHeight * scale)
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
            .frame(height: layout.cardHeight * 0.75)
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
                    .minimumScaleFactor(0.3)
                    .lineLimit(2)
                    .foregroundStyle(debtorColor)
                    .bold()
                    .font(.system(size: maxTransactionNameSize, design: .serif))
                
                //TODO: replace this with word "pays"
                Image(systemName: "arrow.down.square.fill")
                    .font(.system(size: cardWidth * 0.2, design: .serif))
                    //gradient from debtor's color to creditor
                    .foregroundStyle(LinearGradient(
                        gradient: Gradient(colors: [debtorColor, creditorColor]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                        )
                    )
                
                Text(transaction.creditor.name)
                //handles long values by shrinking it down and going on two lines if they do not fit
                    .minimumScaleFactor(0.3)
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
            .frame(height: layout.cardHeight * 0.75)
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
                //shrink the text if it doesn't fit on one line
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            Image(systemName: playerSuit)
                .resizable()
                .frame(width: cardWidth * 0.13, height: cardWidth * 0.13)
        }
        //set the symbols to the player's selected color
        .foregroundStyle(playerColor)
    }
}


//translucent black card used to indicate a lack of player in room view
struct EmptyPlaceholderCardView: View
{
    let cardWidth: CGFloat
    var body: some View
    {
        //make a layout struct to calculate the necessary size of the different views
        let layout = CardLayout(cardWidth: cardWidth)
    
        //subtle background gradient of card with a shadow
        RoundedRectangle(cornerRadius: layout.cardCornerRadius)
            .foregroundStyle(.black)
            .opacity(0.4)
            .frame(width: cardWidth, height: layout.cardHeight)
    }
}

//struct that either returns a player card or an empty placeholder depending on if a player is passed in
struct RoomCardView: View
{
    let cardWidth: CGFloat
    let player: Player?
    var body: some View
    {
        if let cardPlayer = player
        {
            PlayerCardView(cardWidth: cardWidth, player: cardPlayer)
        }
        else
        {
            EmptyPlaceholderCardView(cardWidth: cardWidth)
        }
    }
}


#Preview
{
    let cardWidthSmall: CGFloat = 50
    let cardWidthLarge: CGFloat = 150
    
    let creditor = Player(
        id: UUID(),
        name: "John",
        balance: 1.50,
        cardCustomizationOptions: CardCustomizationOptions()
    )
    
    let debtor = Player(
        id: UUID(),
        name: "Joe. Q",
        balance: -1.50,
        cardCustomizationOptions: CardCustomizationOptions(color: CardColor.red, value: CardValue.king, suit: CardSuit.spades)
    )
    
    let previewTransaction: Transaction = Transaction(id: UUID(), debtor: debtor, creditor: creditor, balance: 1.50)
    
    VStack
    {
        HStack
        {

            PlayerCardView(cardWidth: cardWidthLarge, player: creditor)
            //Spacer()
            PlayerCardView(cardWidth: cardWidthSmall, player: creditor)

        }
        //TransactionCardView(cardWidth: cardWidthLarge, transaction: previewTransaction)
        HStack
        {
            TransactionCardView(cardWidth: cardWidthLarge, transaction: previewTransaction)
            //Spacer()
            TransactionCardView(cardWidth: cardWidthSmall, transaction: previewTransaction)
        }
//        HStack
//        {
//            RoomCardView(cardWidth: cardWidthLarge, player: nil)
//            RoomCardView(cardWidth: cardWidthLarge, player: debtor)
//        }
        //EmptyPlaceholderCardView(cardWidth: cardWidthSmall)
    }
    .padding()
    .background(Color.tableColor)
    //.ignoresSafeArea()
    
}
