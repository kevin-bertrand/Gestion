//
//  UserManager.swift
//  Gestion
//
//  Created by Kevin Bertrand on 01/09/2022.
//

import Foundation
import SwiftUI

final class UserManager {
    // MARK: Static
    static let userUpdate: User.Update = .init(id: UUID(uuid: UUID_NULL),
                                               firstname: "",
                                               lastname: "",
                                               phone: "",
                                               email: "",
                                               gender: .man,
                                               position: .employee,
                                               role: "",
                                               address: Address.Create(roadName: "",
                                                                       streetNumber: "",
                                                                       complement: "",
                                                                       zipCode: "",
                                                                       city: "",
                                                                       country: "",
                                                                       latitude: 0,
                                                                       longitude: 0,
                                                                       comment: ""))
    
    // MARK: Public
    // MARK: Properties
    var connectedUser: User?
    var profilePicutre: UIImage?
    
    // MARK: Methods
    func login(user: User.Login) {
        networkManager.request(urlParams: NetworkConfigurations.staffLogin.urlParams,
                               method: NetworkConfigurations.staffLogin.method,
                               authorization: .authorization(username: user.email, password: user.password),
                               body: User.DeviceToken(token: user.deviceToken)) { [weak self] data, response, error in
            if let self = self,
               let statusCode = response?.statusCode,
               let data = data {
                switch statusCode {
                case 200:
                    if let user = try? JSONDecoder().decode(User.self, from: data) {
                        self.connectedUser = user
                        self.downloadProfilePicture()
                        Notification.Desyntic.loginSuccess.sendNotification()
                    } else {
                        Notification.Desyntic.unknownError.sendNotification()
                    }
                case 401:
                    Notification.Desyntic.loginWrongCredentials.sendNotification()
                default:
                    Notification.Desyntic.unknownError.sendNotification()
                }
            } else {
                Notification.Desyntic.unknownError.sendNotification()
            }
        }
    }
    
    /// Disconnect the user
    func disconnectUser() {
        connectedUser = nil
    }
    
    /// Update user
    func update(user userToUpdate: User.Update, by user: User) {
        networkManager.request(urlParams: NetworkConfigurations.staffUpdate.urlParams,
                               method: NetworkConfigurations.staffUpdate.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: userToUpdate) { [weak self] data, response, error in
            if let self = self,
               let statusCode = response?.statusCode,
               let data = data {
                switch statusCode {
                case 200:
                    if let user = try? JSONDecoder().decode(User.self, from: data) {
                        self.connectedUser = user
                        Notification.Desyntic.userUpdateSuccess.sendNotification()
                    } else {
                        Notification.Desyntic.unknownError.sendNotification()
                    }
                default:
                    Notification.Desyntic.unknownError.sendNotification()
                }
            } else {
                Notification.Desyntic.unknownError.sendNotification()
            }
        }
    }
    
    /// Update password
    func updatePassword(passwords: User.UpdatePassword, by user: User) {
        networkManager.request(urlParams: NetworkConfigurations.staffUpdatePassword.urlParams,
                               method: NetworkConfigurations.staffUpdatePassword.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: passwords) { _, response, error in
            if let status = response?.statusCode {
                switch status {
                case 200:
                    Notification.Desyntic.userUpdatePasswordSuccess.sendNotification(customMessage: passwords.newPassword)
                case 401:
                    Notification.Desyntic.notAuthorized.sendNotification(customMessage: "You are not authorized to update the password")
                case 406:
                    Notification.Desyntic.userUpdatePasswordError.sendNotification(customMessage: "Both new password don't match!")
                case 460:
                    Notification.Desyntic.userUpdatePasswordError.sendNotification(customMessage: "The old password is not correct!")
                default:
                    Notification.Desyntic.unknownError.sendNotification()
                }
            } else {
                Notification.Desyntic.unknownError.sendNotification()
            }
        }
    }
    
    /// update profile picture
    func updateProfilePicture(_ image: UIImage, by user: User) {
        #if os(macOS)
            let imageData = image.jpegDataFrom(image: image)
        #else
            guard let imageData = image.jpegData(compressionQuality: 0.9) else {
                return
            }
        #endif
        
        networkManager.uploadFiles(urlParams: NetworkConfigurations.staffUpdateProfilePicture.urlParams,
                                   method: NetworkConfigurations.staffUpdateProfilePicture.method,
                                   by: user,
                                   file: imageData) { [weak self] data, response, error in
            if let self = self,
               let statusCode = response?.statusCode,
               let data = data {
                switch statusCode {
                case 200:
                    if let user = try? JSONDecoder().decode(User.self, from: data) {
                        self.connectedUser = user
                        self.downloadProfilePicture()
                        Notification.Desyntic.userUpdatePictureSuccess.sendNotification()
                    } else {
                        Notification.Desyntic.unknownError.sendNotification()
                    }
                case 400:
                    Notification.Desyntic.userUpdatePictureError.sendNotification()
                case 401:
                    Notification.Desyntic.notAuthorized.sendNotification(customMessage: "You are not authorized to update the picture.")
                default:
                    Notification.Desyntic.unknownError.sendNotification()
                }
            } else {
                Notification.Desyntic.unknownError.sendNotification()
            }
        }
    }
    
    // MARK: Initialization
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    // MARK: Private
    // MARK: Properties
    private let networkManager: NetworkManager
    
    // MARK: Method
    /// Get profile picture
    private func downloadProfilePicture() {
        if let profilePicturePath = connectedUser?.profilePicture {
            networkManager.downloadProfilePicture(from: profilePicturePath, by: connectedUser, completionHandler: { [weak self] image in
                guard let self = self else { return }
                self.profilePicutre = image
                Notification.Desyntic.userGettingPicture.sendNotification()
            })
        }
    }
}
