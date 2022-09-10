//
//  UserManager.swift
//  Gestion
//
//  Created by Kevin Bertrand on 01/09/2022.
//

import Foundation

final class UserManager {
    // MARK: Static
    static let userUpdate: User.Update = .init(id: UUID(uuid: UUID_NULL), firstname: "", lastname: "", phone: "", email: "", gender: .man, position: .employee, role: "", address: Address.Create(roadName: "", streetNumber: "", complement: "", zipCode: "", city: "", country: "", latitude: 0, longitude: 0, comment: ""))
    
    // MARK: Public
    // MARK: Properties
    var connectedUser: User?
    
    // MARK: Methods
    func login(user: User.Login) {
        networkManager.request(urlParams: NetworkConfigurations.staffLogin.urlParams,
                               method: NetworkConfigurations.staffLogin.method,
                               authorization: .authorization(username: user.email, password: user.password),
                               body: nil) { [weak self] data, response, error in
            if let self = self,
               let statusCode = response?.statusCode,
               let data = data {
                switch statusCode {
                case 200:
                    if let user = try? JSONDecoder().decode(User.self, from: data) {
                        self.connectedUser = user
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
            print(response)
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
    
    // MARK: Initialization
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    // MARK: Private
    // MARK: Properties
    private let networkManager: NetworkManager
}
