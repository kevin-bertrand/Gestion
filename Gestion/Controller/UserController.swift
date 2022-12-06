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
    @Published var userIsConnected: Bool = false
    @Published var userProfilePicture: UIImage?
    var appController: AppController
    var connectedUser: User? { userManager.connectedUser }
    
    // Login properties
    @AppStorage("desyntic-savedEmail", store: UserDefaults(suiteName: "group.com.desyntic.gestion")) var savedEmail: String = ""
    @AppStorage("desyntic-savedPassword", store: UserDefaults(suiteName: "group.com.desyntic.gestion")) var savedPassword: String = ""
    @AppStorage("desyntic-deviceToken") var deviceToken: String = ""
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
    
    // Update user
    @Published var userIsUpdated: Bool = false
    
    // Update password view
    @Published var updateErrorMessage: String = ""
    @Published var updatePasswordSucces: Bool = false
    
    // Update image view
    @Published var updateImageSuccess: Bool = false
    
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
        loginErrorMessage = ""
        
        guard loginEmailTextField.isNotEmpty && loginPasswordTextField.isNotEmpty else {
            loginErrorMessage = "A password and an email are needed!"
            return
        }
        
        guard loginEmailTextField.isEmail else {
            loginErrorMessage = "A valid email address is required!"
            return
        }
        
        appController.setLoadingInProgress(withMessage: "Log in... Please wait!")
        
        print(deviceToken)
        userManager.login(user: User.Login(email: loginEmailTextField,
                                           password: loginPasswordTextField,
                                           deviceToken: deviceToken))
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
    
    /// Ask biometrics activations
    func askBiometricsActivation() {
        if self.savedPassword.isEmpty && self.canUseBiometric {
            activateBiometric()
        }
    }
    
    /// Update user
    func updateUser(_ userToUpdate: User.Update) {
        guard let user = connectedUser else { return }
        appController.setLoadingInProgress(withMessage: "Updating informations...")
        userManager.update(user: userToUpdate, by: user)
    }
    
    /// Update password
    func updatePassword(_ update: User.UpdatePassword) {
        guard update.newPassword.isValidPassword || update.newPasswordVerification.isValidPassword else {
            updateErrorMessage = "The new passwords don't meet the required standards!"
            return
        }
        
        guard update.newPassword == update.newPasswordVerification else {
            updateErrorMessage = "Both passwords must match!"
            return
        }
        
        guard let user = connectedUser else {
            return
        }
        
        appController.setLoadingInProgress(withMessage: "Updating passwords...")
        
        userManager.updatePassword(passwords: update, by: user)
    }
    
    /// Update profilte picture
    func updateProfilePicture(_ image: UIImage) {
        guard let user = connectedUser else {
            return
        }
        
        appController.setLoadingInProgress(withMessage: "Updating profile picture...")
        
        userManager.updateProfilePicture(image, by: user)
    }
    
    // MARK: Initialization
    init(appController: AppController) {
        self.appController = appController
        
        // Configure login notification
        configureNotification(for: Notification.Desyntic.loginSuccess.notificationName)
        configureNotification(for: Notification.Desyntic.loginWrongCredentials.notificationName)
        configureNotification(for: Notification.Desyntic.userGettingPicture.notificationName)
        
        // Configure update notifications
        configureNotification(for: Notification.Desyntic.userUpdateSuccess.notificationName)
        configureNotification(for: Notification.Desyntic.userUpdatePasswordSuccess.notificationName)
        configureNotification(for: Notification.Desyntic.userUpdatePasswordError.notificationName)
        configureNotification(for: Notification.Desyntic.userUpdatePictureSuccess.notificationName)
        configureNotification(for: Notification.Desyntic.userUpdatePictureError.notificationName)
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
                    self.userIsConnected = true
                    self.saveNewPassword(with: self.loginPasswordTextField)
                case Notification.Desyntic.loginWrongCredentials.notificationName,
                    Notification.Desyntic.userUpdatePictureError.notificationName:
                    self.appController.showAlertView(withMessage: notificationMessage, andTitle: "Error")
                case Notification.Desyntic.userUpdateSuccess.notificationName:
                    self.userIsUpdated = true
                case Notification.Desyntic.userUpdatePasswordSuccess.notificationName:
                    self.updatePasswordSucces = true
                    self.saveNewPassword(with: notificationMessage)
                case Notification.Desyntic.userUpdatePasswordError.notificationName:
                    self.updateErrorMessage = notificationMessage
                case Notification.Desyntic.userUpdatePictureSuccess.notificationName:
                    self.updateImageSuccess = true
                case Notification.Desyntic.userGettingPicture.notificationName:
                    self.userProfilePicture = self.userManager.profilePicutre
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
    
    /// Saved the new pass
    private func saveNewPassword(with newPassword: String) {
        updateErrorMessage = ""
        if canUseBiometric {
            savedPassword = newPassword
        }
    }
}
