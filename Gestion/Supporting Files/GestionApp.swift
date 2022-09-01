//
//  GestionApp.swift
//  Gestion
//
//  Created by Kevin Bertrand on 29/08/2022.
//

import SwiftUI

@main
struct GestionApp: App {
    @StateObject private var appController: AppController
    @StateObject private var userController: UserController
    
    // Initialization
    init() {
        let appController = AppController()
        _appController = StateObject(wrappedValue: appController)
        _userController = StateObject(wrappedValue: UserController(appController: appController))
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                ZStack {
                    Group {
                        if userController.userIsConnected {
                            AppView()
                        } else {
                            StartView()
                        }
                    }
                    .disabled(appController.loadingInProgress)
                    
                    if appController.loadingInProgress {
                        LoadingInProgressView()
                    }
                }
            }
            .environmentObject(userController)
            .environmentObject(appController)
            .alert(isPresented: $appController.showAlertView) {
                Alert(title: Text(appController.alertViewTitle), message: Text(appController.alertViewMessage), dismissButton: .default(Text("OK")))
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
        }
    }
}
