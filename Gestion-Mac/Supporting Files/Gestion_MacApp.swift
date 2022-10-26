//
//  Gestion_MacApp.swift
//  Gestion-Mac
//
//  Created by Kevin Bertrand on 22/10/2022.
//

import SwiftUI

@main
struct Gestion_MacApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView()
                .frame(minWidth: 1500, minHeight: 90)
        }
    }
}
