//
//  iPhoneTabView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 20/10/2022.
//

import SwiftUI

struct iPhoneTabView: View {
    @EnvironmentObject var userController: UserController
    @State private var selectedTab: Int = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                HomeView(selectedTab: $selectedTab)
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(1)
            
            NavigationStack {
                EstimatesView()
            }
            .tabItem {
                Label("Estimates", systemImage: "pencil.and.ruler.fill")
            }
            .tag(2)
            
            NavigationStack {
                InvoicesView()
            }
            .tabItem {
                Label("Invoices", systemImage: "eurosign")
            }
            .tag(3)
            
            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape.2.fill")
            }
            .tag(4)
        }
        .alert(isPresented: $userController.loginShowBiometricAlert) {
            Alert(title: Text("Would you like to use FaceId for further login?"),
                  primaryButton: .default(Text("Yes"), action: {
                userController.canUseBiometric = true
            }),
                  secondaryButton: .cancel(Text("No"), action: {
                userController.canUseBiometric = false
            }))
        }
        .onAppear {
            userController.askBiometricsActivation()
        }
    }
}

struct iPhoneTabView_Previews: PreviewProvider {
    static var previews: some View {
        iPhoneTabView()
    }
}
