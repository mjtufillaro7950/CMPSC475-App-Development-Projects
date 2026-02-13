//
//  DesignConstants.swift
//  Lion Spell
//
//  Created by LiasPub on 2/13/26.
//

import SwiftUI

struct CustomColors
{
    let brightPurple: Color = Color(red: 0.6, green: 0.2, blue: 1.0)
}

struct DesignConstants
{
    static let mainColor: Color = Color(red: 0.6, green: 0.2, blue: 1.0)
    //a lighter version of the main color
    static let lighterColor: Color = Color(red: 0.8, green: 0.60, blue: 1.0)
    static let accentColorOne: Color = .yellow
    static let accentColorTwo: Color = .green
    static let cornerRadius: CGFloat = 16
}

//TODO: test colors
struct testView: View
{
    var body: some View
    {
        VStack
        {
            Circle()
                .foregroundColor(DesignConstants.mainColor)
            Circle()
                .foregroundColor(DesignConstants.lighterColor)
            Circle()
                .foregroundColor(DesignConstants.accentColorOne)
            Circle()
                .foregroundColor(DesignConstants.accentColorTwo)
        }
        .frame(width: 50)
    }
}
#Preview
{
    testView()
}
