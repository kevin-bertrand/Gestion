//
//  EstimatesManager.swift
//  Gestion
//
//  Created by Kevin Bertrand on 01/09/2022.
//

import Foundation

final class EstimatesManager {
    // MARK: Public
    // MARK: Properties
    var estimatesSummary: [Estimate.Summary] = []
    
    // MARK: Methods
    /// Download three latest estimates
    func downloadThreeLatests(for user: User) {
        var params = NetworkConfigurations.estimateGetList.urlParams
        params.append("3")
        networkManager.request(urlParams: params, method: NetworkConfigurations.estimateGetList.method, authorization: .authorization(bearerToken: user.token), body: nil) { [weak self] data, response, error in
            if let self = self,
               let statusCode = response?.statusCode,
               let data = data,
               statusCode == 200,
               let estimates = try? JSONDecoder().decode([Estimate.Summary].self, from: data) {
                self.estimatesSummary = estimates
                Notification.Desyntic.estimatesSummarySuccess.sendNotification()
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
