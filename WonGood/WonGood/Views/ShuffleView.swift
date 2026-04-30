//
//  ShuffleView.swift
//  WonGood
//
//  Created by Michael Tufillaro on 4/14/26.
//

import SwiftUI

struct ShuffleView: View
{
    @Environment(GameSessionManager.self) var gameSessionManager
    
    var body: some View
    {
        //display a random quote from the dealer
        Text("\"\(gameSessionManager.randomDealerQuote())\"")
            .font(.system(size: 30, design: .serif))
            .bold()
            .foregroundStyle(Color.dealerGray)
            .padding(.horizontal)
        Spacer()
        ProgressView()
            .progressViewStyle(.circular)
            .tint(Color.dealerGray)
            .scaleEffect(3.0)
        Spacer()
    }
}

#Preview
{
    @Previewable @State var manager = GameSessionManager()
    MainView()
        .environment(manager)
        .onAppear
        {
            manager.phase = .shuffle
        }
}
