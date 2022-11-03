//
//  AppView.swift
//  Gestion-Mac
//
//  Created by Kevin Bertrand on 27/10/2022.
//

import SwiftUI

struct AppView: View {
    @State private var selectedView: Int? = 1
    @State private var selectedTab: Int = 1
    
    var body: some View {
        NavigationView {
            List(selection: $selectedView) {
                NavigationLink {
                    HomeView()
                } label: {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(1)
                NavigationLink {
                    EstimatesView()
                } label: {
                    Label("Estimates", systemImage: "house.fill")
                }
                .tag(2)
                NavigationLink {
                    Text("Invoices")
                } label: {
                    Label("Invoices", systemImage: "eurosign")
                }
                .tag(3)
                NavigationLink {
                    Text("Settings")
                } label: {
                    Label("Settings", systemImage: "gear.fill")
                }
                .tag(4)
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
