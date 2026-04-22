//
//  CardView.swift
//  WonGood
//
//  Created by Michael Tufillaro on 4/21/26.
//

import SwiftUI

struct CardView: View
{
    let cardWidth: CGFloat
    
    //get the corner radius and height of the card relative to its width
    var cardCornerRadius: CGFloat
    {
        return cardWidth / 15
    }
    
    var cardStrokeWidth: CGFloat
    {
        return cardWidth / 20
    }
    
    var cardHeight: CGFloat
    {
        return 1.4 * cardWidth
    }
    
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
            RoundedRectangle(cornerRadius: cardCornerRadius)
                .stroke(lineWidth: cardStrokeWidth)
            
            RoundedRectangle(cornerRadius: cardCornerRadius)
                .foregroundStyle(cardGradient)
        }
        .frame(width: cardWidth, height: cardHeight)
    }
}

#Preview
{
    let cardWidth: CGFloat = 150
    CardView(cardWidth: cardWidth)
}
