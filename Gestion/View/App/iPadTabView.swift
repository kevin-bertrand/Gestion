//
//  iPadTabView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 20/10/2022.
//

import SwiftUI

struct iPadTabView: View {
    @EnvironmentObject var userController: UserController
    @State private var columnVisibility = NavigationSplitViewVisibility.doubleColumn
    @State private var selectedView: Int? = 1
    @State private var selectedTab: Int = 1
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility, sidebar: {
            List(selection: $selectedView) {
                Text("Home")
                    .tag(1)
                Text("Estimates")
                    .tag(2)
                Text("Invoices")
                    .tag(3)
                Text("Settings")
                    .tag(4)
            }
        }, detail: {
            switch selectedView {
            case 1:
                HomeView(selectedTab: $selectedTab)
            case 2:
                EstimatesView()
            case 3:
                InvoicesView()
            case 4:
                SettingsView()
            default:
                Text("Hello")
            }
        })
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
        .onChange(of: selectedView ?? 0) { newValue in
            selectedTab = newValue
        }
    }
}

struct iPadTabView_Previews: PreviewProvider {
    static var previews: some View {
        iPadTabView()
            .environmentObject(UserController(appController: AppController()))
    }
}
