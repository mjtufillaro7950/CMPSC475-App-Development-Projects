//
//  CurrentWordView.swift
//  Lion Spell
//
//  Created by LiasPub on 1/25/26.
//

import SwiftUI

struct CurrentWordView: View
{
    var body: some View
    {
        Text("Current Word")
        RoundedRectangle(cornerRadius: 16)
            .frame(height: 50)
            .foregroundColor(.cyan)
    }
}

#Preview {
    MainView()
}
