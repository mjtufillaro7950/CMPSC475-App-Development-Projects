//
//  CircleImage.swift
//  Landmarks
//
//  Created by LiasPub on 1/24/26.
//

import SwiftUI

struct CircleImage: View {
    var body: some View {
        Image("Headshot")
            .clipShape(Circle())
    }
}

#Preview {
    CircleImage()
}
