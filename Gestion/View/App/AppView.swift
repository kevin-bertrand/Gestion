//
//  AppView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 30/08/2022.
//

import SwiftUI

struct AppView: View {
    @State private var selectedTab: Int = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                HomeView(selectedTab: $selectedTab)
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(1)
            
            NavigationView {
                EstimatesView()
            }
            .tabItem {
                Label("Estimates", systemImage: "pencil.and.ruler.fill")
            }
            .tag(2)
            
            NavigationView {
                InvoicesView()
            }
            .tabItem {
                Label("Invoices", systemImage: "eurosign")
            }
            .tag(3)
            
            NavigationView {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape.2.fill")
            }
            .tag(4)
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
