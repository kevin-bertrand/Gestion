//
//  PaymentManager.swift
//  Gestion
//
//  Created by Kevin Bertrand on 07/09/2022.
//

import Foundation

final class PaymentManager {
    // MARK: Public
    // MARK: Properties
    var payments: [Payment] = []
    
    // MARK: Methods
    /// Getting all payment method
    func gettingPaymentList(by user: User) {
        networkManager.request(urlParams: NetworkConfigurations.paymentGetList.urlParams,
                               method: NetworkConfigurations.paymentGetList.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: nil) { [weak self] data, response, error in
            if let self = self,
               let statusCode = response?.statusCode,
               statusCode == 200,
               let data = data,
               let payments = try? JSONDecoder().decode([Payment].self, from: data) {
                self.payments = payments
                Notification.Desyntic.paymentGettingList.sendNotification()
            } else {
                Notification.Desyntic.unknownError.sendNotification()
            }
        }
    }
    
    /// Update payment method
    func update(method: Payment, by user: User) {
        networkManager.request(urlParams: NetworkConfigurations.paymentUpdate.urlParams,
                               method: NetworkConfigurations.paymentUpdate.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: method) { _, response, error in
            if let statusCode = response?.statusCode {
                switch statusCode {
                case 200:
                    Notification.Desyntic.paymentUpdateSuccess.sendNotification()
                case 401, 406:
                    Notification.Desyntic.paymentUpdateError.sendNotification()
                default:
                    Notification.Desyntic.unknownError.sendNotification()
                }
            } else {
                Notification.Desyntic.unknownError.sendNotification()
            }
        }
    }
    
    /// Create a new payment method
    func create(method: Payment.Create, by user: User) {
        networkManager.request(urlParams: NetworkConfigurations.paymentAdd.urlParams,
                               method: NetworkConfigurations.paymentAdd.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: method) { _, response, error in
            if let statusCode = response?.statusCode {
                switch statusCode {
                case 201:
                    Notification.Desyntic.paymentCreationSuccess.sendNotification()
                case 401:
                    Notification.Desyntic.paymentCreationError.sendNotification()
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
