//
//  InvoicesManager.swift
//  Gestion
//
//  Created by Kevin Bertrand on 01/09/2022.
//

import Foundation

final class InvoicesManager {
    // MARK: Public
    // MARK: Properties
    var invoicesSummary: [Invoice.Summary] = []
    
    // MARK: Methods
    /// Download three latest invoices
    func downloadThreeLatests(for user: User) {
        var params = NetworkConfigurations.invoiceGetList.urlParams
        params.append("filter")
        params.append("3")
        networkManager.request(urlParams: params, method: NetworkConfigurations.invoiceGetList.method, authorization: .authorization(bearerToken: user.token), body: nil) { [weak self] data, response, error in
            if let self = self,
               let statusCode = response?.statusCode,
               let data = data,
               statusCode == 200,
               let invoices = try? JSONDecoder().decode([Invoice.Summary].self, from: data) {
                self.invoicesSummary = invoices
                Notification.Desyntic.invoicesSummarySuccess.sendNotification()
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
