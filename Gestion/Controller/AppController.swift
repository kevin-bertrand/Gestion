//
//  AppController.swift
//  Gestion
//
//  Created by Kevin Bertrand on 01/09/2022.
//

import Foundation
import LocalAuthentication

final class AppController: ObservableObject {
    // MARK: Public
    // MARK: Properties
    // Loading view
    @Published var loadingInProgress: Bool = false
    var loadingMessage: String = ""
    
    // Alert view
    @Published var showAlertView: Bool = false
    var alertViewMessage: String = ""
    var alertViewTitle: String = ""
    
    // Check Biometrics
    var isBiometricAvailable: Bool {
        let laContext = LAContext()
        return laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: .none)
    }
    
    // MARK: Methods
    /// Setting loading in progress
    func setLoadingInProgress(withMessage message: String) {
        DispatchQueue.main.async {
            self.loadingInProgress = true
            self.loadingMessage = message
        }
    }
    
    /// Reset loading in progress
    func resetLoadingInProgress() {
        loadingMessage = ""
        loadingInProgress = false
    }
    
    /// Show an alert view
    func showAlertView(withMessage message: String, andTitle title: String) {
        alertViewMessage = message
        alertViewTitle = title
        showAlertView = true
    }
    
    /// Reset alert view
    func resetAlertView() {
        alertViewMessage = ""
        alertViewTitle = ""
    }
    
    // MARK: Initialization
    init() {
        // Configure general notifications
        configureNotification(for: Notification.Desyntic.unknownError.notificationName)
    }
    
    // MARK: Private
    // MARK: Properties
    
    // MARK: Methods
    /// Configure notification
    private func configureNotification(for name: Notification.Name) {
        NotificationCenter.default.addObserver(self, selector: #selector(processNotification), name: name, object: nil)
    }
    
    /// Initialise all notification for this controller
    @objc private func processNotification(_ notification: Notification) {
        if let notificationName = notification.userInfo?["name"] as? Notification.Name,
           let notificationMessage = notification.userInfo?["message"] as? String {
            self.resetLoadingInProgress()
            
            switch notificationName {
            case Notification.Desyntic.unknownError.notificationName:
                self.showAlertView(withMessage: notificationMessage, andTitle: "Error")
            default: break
            }
        }
    }
}
