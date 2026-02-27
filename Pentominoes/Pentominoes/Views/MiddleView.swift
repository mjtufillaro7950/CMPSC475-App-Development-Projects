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
        Text("TODO: REMOVE THIS")
        //TODO: add title, then 14 x 14 puzzle grid, then initialize the pieces?
    }
}

#Preview {
    MiddleView()
        .environment(ViewModel())
}
