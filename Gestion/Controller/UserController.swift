//
//  UserController.swift
//  Gestion
//
//  Created by Kevin Bertrand on 01/09/2022.
//

import Foundation
import LocalAuthentication
import SwiftUI

final class UserController: ObservableObject {
    // MARK: Public
    // MARK: Properties
    // General properties
    var appController: AppController
    @Published var userIsConnected: Bool = false
    
    // Login properties
    @AppStorage("desyntic-savedEmail") var savedEmail: String = ""
    @AppStorage("desyntic-savedPassword") var savedPassword: String = ""
    @AppStorage("desyntic-canUseBiometric") var canUseBiometric: Bool = true {
        didSet {
            if canUseBiometric {
                activateBiometric()
            } else {
                savedPassword = ""
            }
        }
    }
    
    @Published var loginShowBiometricAlert: Bool = false
    @Published var loginSaveEmail: Bool = false
    @Published var loginEmailTextField: String = ""
    @Published var loginPasswordTextField: String = ""
    @Published var loginErrorMessage: String = ""
    
    // MARK: Methods
    /// Check if the email must be saved
    func checkSaveEmail() {
        if loginSaveEmail {
            savedEmail = loginEmailTextField
        } else {
            savedEmail = ""
        }
    }
    
    /// Getting biometrics status to know if it is active
    func getBiometricStatus() -> Bool {
        if savedEmail == loginEmailTextField && savedPassword.isNotEmpty && appController.isBiometricAvailable {
            return true
        }
        
        return false
    }
    
    /// Perfom login
    func performLogin() {        
        appController.setLoadingInProgress(withMessage: "Log in... Please wait!")
        loginErrorMessage = ""
        
        guard loginEmailTextField.isNotEmpty && loginPasswordTextField.isNotEmpty else {
            loginErrorMessage = "A password and an email are needed!"
            appController.resetLoadingInProgress()
            return
        }
        
        guard loginEmailTextField.isEmail else {
            loginErrorMessage = "A valid email address is required!"
            appController.resetLoadingInProgress()
            return
        }
        
        userManager.login(user: User.Login(email: loginEmailTextField, password: loginPasswordTextField))
    }
    
    /// Login with biometrics
    func loginWithBiometrics() {
        var error: NSError?
        let laContext = LAContext()
        
        if laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Need access to \(laContext.biometryType == .faceID ? "FaceId" : "TouchId") to authenticate to the app."
            
            laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                DispatchQueue.main.async {
                    if success {
                        self.loginPasswordTextField = self.savedPassword
                        self.performLogin()
                    } else {
                        print(error?.localizedDescription ?? "error")
                    }
                }
            }
        }
    }
    
    /// Disconnect the user
    func disconnectUser() {
        DispatchQueue.main.async {
            self.loginPasswordTextField = ""
            self.userIsConnected = false
            self.userManager.disconnectUser()
        }
    }
    
    // MARK: Initialization
    init(appController: AppController) {
        self.appController = appController
        
        // Configure login notification
        configureNotification(for: Notification.Desyntic.loginSuccess.notificationName)
        configureNotification(for: Notification.Desyntic.loginWrongCredentials.notificationName)
    }
    
    // MARK: Private
    // MARK: Properties
    private let userManager = UserManager()
    
    // MARK: Methods
    /// Configure notification
    private func configureNotification(for name: Notification.Name) {
        NotificationCenter.default.addObserver(self, selector: #selector(processNotification), name: name, object: nil)
    }
    
    /// Initialise all notification for this controller
    @objc private func processNotification(_ notification: Notification) {
        if let notificationName = notification.userInfo?["name"] as? Notification.Name,
           let notificationMessage = notification.userInfo?["message"] as? String {
            DispatchQueue.main.async {
                self.appController.resetLoadingInProgress()
                
                switch notificationName {
                case Notification.Desyntic.loginSuccess.notificationName:
                    self.actionWhenLoginSuccess()
                case Notification.Desyntic.loginWrongCredentials.notificationName:
                    self.appController.showAlertView(withMessage: notificationMessage, andTitle: "Error")
                default: break
                }
            }
        }
    }
    
    /// Getting biometric authentication to active it
    private func activateBiometric() {
        var error: NSError?
        let laContext = LAContext()
        
        if laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Need access to \(laContext.biometryType == .faceID ? "FaceId" : "TouchId") to authenticate to the app."
            
            laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                DispatchQueue.main.async {
                    if success {
                        self.savedEmail = self.loginEmailTextField
                        self.savedPassword = self.loginPasswordTextField
                        self.appController.showAlertView(withMessage: "Biometrics is now active!", andTitle: "Success")
                    } else {
                        print(error?.localizedDescription ?? "error")
                    }
                }
            }
        }
    }
    
    /// Perfom action when login success
    private func actionWhenLoginSuccess() {
        DispatchQueue.main.async {
            if self.savedPassword.isEmpty && self.canUseBiometric {
                print("ok")
                self.loginShowBiometricAlert = true
            }

            self.userIsConnected = true
        }
    }
}
