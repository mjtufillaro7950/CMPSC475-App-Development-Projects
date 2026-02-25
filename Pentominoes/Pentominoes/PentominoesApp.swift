//
//  PentominoesApp.swift
//  Pentominoes
//
//  Created by Michael Tufillaro on 2/19/26.
//

import SwiftUI

@main
struct PentominoesApp: App
{
    //create an instance of the viewmodel
    @State var manager: ViewModel = ViewModel()
    var body: some Scene
    {
        WindowGroup
        {
            MainView()
                .environment(manager)
        }
    }
}
