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
    var clients: [Client.Informations] = []
    
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
               let clients = try? JSONDecoder().decode([Client.Informations].self, from: data) {
                self.clients = clients
                Notification.Desyntic.clientGettingList.sendNotification()
            } else {
                Notification.Desyntic.unknownError.sendNotification()
            }
        }
    }
    
    /// Update client
    func update(client: Client.Informations, by user: User) {
        guard let clientId = client.id else {
            Notification.Desyntic.unknownError.sendNotification()
            return
        }
        var params = NetworkConfigurations.clientUpdate.urlParams
        params.append("\(clientId)")
        networkManager.request(urlParams: params,
                               method: NetworkConfigurations.clientUpdate.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: client) { _, response, error in
            if let statusCode = response?.statusCode {
                switch statusCode{
                case 200:
                    Notification.Desyntic.clientUpdated.sendNotification()
                case 401, 406:
                    Notification.Desyntic.clientUpdateError.sendNotification()
                default:
                    Notification.Desyntic.unknownError.sendNotification()
                }
            } else {
                Notification.Desyntic.unknownError.sendNotification()
            }
        }
    }
    
    /// Create client
    func create(client: Client.Create, by user: User) {
        networkManager.request(urlParams: NetworkConfigurations.clientAdd.urlParams,
                               method: NetworkConfigurations.clientAdd.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: client) { _, response, error in
            if let statusCode = response?.statusCode {
                switch statusCode{
                case 201:
                    Notification.Desyntic.clientCreateSuccess.sendNotification()
                case 401:
                    Notification.Desyntic.clientCreateError.sendNotification()
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
    
    // MARK: Methods
    
}
