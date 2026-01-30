//
//  Lion_SpellApp.swift
//  Lion Spell
//
//  Created by LiasPub on 1/24/26.
//

import SwiftUI

@main
struct Lion_SpellApp: App
{
    // creates an instance of the viewmodel
    @State var manager: ViewModel = ViewModel()
    var body: some Scene
    {
        WindowGroup {
            MainView()
            //passes the viewmodel into the view
                .environment(manager)
        }
    }
}
