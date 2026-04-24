//
//  CardView.swift
//  WonGood
//
//  Created by Michael Tufillaro on 4/21/26.
//

import SwiftUI

struct CardView: View
{
    //pass in the size of the card and the player its for
    let cardWidth: CGFloat
    let player: Player
    
    //get different sizing values as a function of the width so that it looks the same at all sizes
    var cardCornerRadius: CGFloat{ return cardWidth / 15 }
    var cardStrokeWidth: CGFloat{ return cardWidth / 20 }
    var cardHeight: CGFloat{  return 1.4 * cardWidth }
    var shadowRadius: CGFloat{ return 0.08 * cardWidth }
    var paddingSize: CGFloat{ return 0.05 * cardWidth }
    
    var cardGradient: LinearGradient
    {
        let cardColorOne = Color( #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) )
        let cardColorTwo = Color( #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) )
        
        
        return LinearGradient(gradient: Gradient(colors: [cardColorOne, cardColorTwo]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    var body: some View
    {
        //TODO: make a view for the player cards
            //need a zstack with:
            //rounded rectangle forming main card
            //number and symbol pair in top left and upside down in bottom right
            //in the middle, name and balance
        //TODO: make a view for transaction card
            //two options: make the card look like one of the players cards, OR, make one of the symbol/number pairs be that of the creditor and one of the debtor.
        
        //Text("CardView")
        ZStack
        {
            //border of card
            RoundedRectangle(cornerRadius: cardCornerRadius)
                .stroke(lineWidth: cardStrokeWidth)
            
            //subtle background gradient of card with a shadow
            RoundedRectangle(cornerRadius: cardCornerRadius)
                .foregroundStyle(cardGradient)
                .shadow(radius: shadowRadius)
            VStack
            {
                //add the corner design in the top left of card
                HStack
                {
                    CardCornerDesign(cardWidth: cardWidth, player: player)
                    
                    Spacer()
                }
                
                Spacer()
                
                //TODO: name and balance in middle
                Text("Name and Balance Stuff Here")
                
                Spacer()
                
                //same corner design, upside down and on the bottom right
                HStack
                {
                    Spacer()
                    
                    CardCornerDesign(cardWidth: cardWidth, player: player)
                        .rotationEffect(.degrees(180))
                }
            }
            //TODO: make padding size dependant on cardSize for obvious reasons
            .padding(paddingSize)
        }
        .frame(width: cardWidth, height: cardHeight)
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
        VStack
        {
            //add the player's selected value and suit
            Text(playerValue)
                .bold()
                .font(.system(size: cardWidth * 0.2, design: .serif))
            Image(systemName: playerSuit)
                .font(.system(size: cardWidth * 0.1))
        }
        //set the symbols to the player's selected color
        .foregroundStyle(playerColor)
    }
}


#Preview
{
    let cardWidthSmall: CGFloat = 150
    let cardWidthLarge: CGFloat = 300
    
    let previewPlayer = Player(id: UUID(), name: "Mike", balance: 50.00, cardCustomizationOptions: CardCustomizationOptions())
    
    CardView(cardWidth: cardWidthLarge, player: previewPlayer)
    Spacer()
    CardView(cardWidth: cardWidthSmall, player: previewPlayer)
}
