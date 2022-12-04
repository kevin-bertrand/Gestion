//
//  GestionApp.swift
//  Gestion
//
//  Created by Kevin Bertrand on 29/08/2022.
//

import SwiftUI

@main
struct GestionApp: App {
    // Setting App Delegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // Getting color scheme settings store in memory
    @AppStorage("desyntic_useDefaultScheme") var useDefaultColorScheme: Bool = true
    @AppStorage("desyntic_useDarkMode") var useDarkMode: Bool = false
    
    // Declaration of state objects
    @StateObject private var appController: AppController
    @StateObject private var userController: UserController
    @StateObject private var revenuesController: RevenuesController
    @StateObject private var estimatesController: EstimatesController
    @StateObject private var invoicesController: InvoicesController
    @StateObject private var clientController: ClientController
    @StateObject private var productController: ProductsController
    @StateObject private var paymentController: PaymentController
    
    // Initialization
    init() {
        let appController = AppController()
        _appController = StateObject(wrappedValue: appController)
        _userController = StateObject(wrappedValue: UserController(appController: appController))
        _revenuesController = StateObject(wrappedValue: RevenuesController(appController: appController))
        _estimatesController = StateObject(wrappedValue: EstimatesController(appController: appController))
        _invoicesController = StateObject(wrappedValue: InvoicesController(appController: appController))
        _clientController = StateObject(wrappedValue: ClientController(appController: appController))
        _productController = StateObject(wrappedValue: ProductsController(appController: appController))
        _paymentController = StateObject(wrappedValue: PaymentController(appController: appController))
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
            .environmentObject(revenuesController)
            .environmentObject(estimatesController)
            .environmentObject(invoicesController)
            .environmentObject(clientController)
            .environmentObject(productController)
            .environmentObject(paymentController)
            .preferredColorScheme(useDefaultColorScheme ? nil : (useDarkMode ? .dark : .light))
            .alert(isPresented: $appController.showAlertView) {
                Alert(title: Text(appController.alertViewTitle), message: Text(appController.alertViewMessage), dismissButton: .default(Text("OK")))
            }
            .onAppear {
                UNUserNotificationCenter
                    .current()
                    .requestAuthorization(options: [.alert, .sound, .badge]) {_, _ in}
            }
        }
    }
}
