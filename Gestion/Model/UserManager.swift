//
//  UserManager.swift
//  Gestion
//
//  Created by Kevin Bertrand on 01/09/2022.
//

import Foundation

final class UserManager {
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
    
    // MARK: Initialization
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    // MARK: Private
    // MARK: Properties
    private let networkManager: NetworkManager
    
    // MARK: Properties
    // MARK: Methods
}
