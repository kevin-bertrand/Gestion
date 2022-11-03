//
//  Gestion_MacApp.swift
//  Gestion-Mac
//
//  Created by Kevin Bertrand on 22/10/2022.
//

import SwiftUI

@main
struct Gestion_MacApp: App {
    @State private var isConnected: Bool = true
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isConnected {
                    AppView()
                } else {
                    LoginView(isConnected: $isConnected)
                }
            }.frame(minWidth: 1250, minHeight: 800)
        }
    }
}
