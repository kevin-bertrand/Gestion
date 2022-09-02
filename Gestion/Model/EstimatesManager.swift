//
//  EstimatesManager.swift
//  Gestion
//
//  Created by Kevin Bertrand on 01/09/2022.
//

import Foundation

final class EstimatesManager {
    // MARK: Static
    static let emptyDetail = Estimate.Informations(id: UUID(uuid: UUID_NULL), reference: "", internalReference: "", object: "", totalServices: 0, totalMaterials: 0, totalDivers: 0, total: 0, reduction: 0, grandTotal: 0, status: .accepted, limitValidityDate: Date(), isArchive: true, client: Client.Informations(firstname: "", lastname: "", company: "", phone: "", email: "", personType: .company, gender: .man, siret: "", tva: "", address: Address(id: "", roadName: "", streetNumber: "", complement: "", zipCode: "", city: "", country: "", latitude: 0, longitude: 0, comment: "")), products: [])
    
    // MARK: Public
    // MARK: Properties
    var estimatesSummary: [Estimate.Summary] = []
    var estimatesList: [Estimate.Summary] = []
    var estimateDetail: Estimate.Informations = EstimatesManager.emptyDetail
    
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
    
    /// Download all estimates
    func downloadAllEstimates(for user: User) {
        networkManager.request(urlParams: NetworkConfigurations.estimateGetList.urlParams,
                               method: NetworkConfigurations.estimateGetList.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: nil) { [weak self] data, response, error in
            if let self = self,
               let status = response?.statusCode,
               let data = data,
               status == 200,
               let estimates = try? JSONDecoder().decode([Estimate.Summary].self, from: data) {
                self.estimatesList = estimates
                Notification.Desyntic.estimatesListDownload.sendNotification()
            } else {
                Notification.Desyntic.unknownError.sendNotification()
            }
        }
    }
    
    /// Download estimate detail
    func downloadEstimateDetails(id: UUID, for user: User) {
        var params = NetworkConfigurations.estimateGetDetails.urlParams
        params.append("\(id)")
        networkManager.request(urlParams: params,
                               method: NetworkConfigurations.estimateGetDetails.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: nil) { [weak self] data, response, error in
            if let self = self,
               let status = response?.statusCode,
               let data = data,
               status == 200,
               let estimate = try? JSONDecoder().decode(Estimate.Informations.self, from: data) {
                self.estimateDetail = estimate
                Notification.Desyntic.estimateGettingOne.sendNotification()
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
