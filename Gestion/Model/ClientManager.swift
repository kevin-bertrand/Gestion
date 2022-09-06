//
//  ClientManager.swift
//  Gestion
//
//  Created by Kevin Bertrand on 06/09/2022.
//

import Foundation

final class ClientManager {
    // MARK: Public
    // MARK: Properties
    var clients: [Client] = []
    
    // MARK: Methods
    /// Getting client list
    func getList(for user: User) {
        networkManager.request(urlParams: NetworkConfigurations.clientGetList.urlParams,
                               method: NetworkConfigurations.clientGetList.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: nil) { [weak self] data, response, error in
            if let self = self,
               let statusCode = response?.statusCode,
               statusCode == 200,
               let data = data,
               let clients = try? JSONDecoder().decode([Client].self, from: data) {
                self.clients = clients
                Notification.Desyntic.clientGettingList.sendNotification()
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
    
    // MARK: Methods
    
}
