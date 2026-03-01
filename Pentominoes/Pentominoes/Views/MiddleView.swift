//
//  MiddleView.swift
//  Pentominoes
//
//  Created by Michael Tufillaro on 2/26/26.
//

import SwiftUI

struct MiddleView: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    
    var body: some View
    {
        VStack
        {
            //TODO: make title look fancy
            Text("PENTOMINOES")
            ZStack(alignment: .topLeading)
            {
                BoardView()
                //for each outline, make a pentomino shape and place it
                ForEach(manager.pieces, id: \.outline.name)
                {
                    piece in
                    PieceView(piece: piece)
                }
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    MiddleView()
        .environment(ViewModel())
}
