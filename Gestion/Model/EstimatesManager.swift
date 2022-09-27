//
//  EstimatesManager.swift
//  Gestion
//
//  Created by Kevin Bertrand on 01/09/2022.
//

import Foundation

final class EstimatesManager {
    // MARK: Static
    static let emptyDetail = Estimate.Informations(id: UUID(uuid: UUID_NULL), reference: "", internalReference: "", object: "", totalServices: 0, totalMaterials: 0, totalDivers: 0, total: 0, status: .accepted, limitValidityDate: Date(), sendingDate: Date(), isArchive: true, client: Client.Informations(id: nil, firstname: "", lastname: "", company: "", phone: "", email: "", personType: .company, gender: .man, siret: "", tva: "", address: Address(id: "", roadName: "", streetNumber: "", complement: "", zipCode: "", city: "", country: "", latitude: 0, longitude: 0, comment: "")), products: [])
    
    // MARK: Public
    // MARK: Properties
    var estimatesSummary: [Estimate.Summary] = []
    var estimatesList: [Estimate.Summary] = []
    var estimateDetail: Estimate.Informations = EstimatesManager.emptyDetail
    var estimatePdf: Data = Data()
    
    // MARK: Methods
    /// Getting new estimate reference
    func gettingNewReference(by user: User) {
        networkManager.request(urlParams: NetworkConfigurations.estimateGetReference.urlParams,
                               method: NetworkConfigurations.estimateGetReference.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: nil) { data, response, error in
            if let statusCode = response?.statusCode,
               statusCode == 200,
               let data = data,
               let reference = try? JSONDecoder().decode(String.self, from: data) {
                Notification.Desyntic.estimateGettingReference.sendNotification(customMessage: reference)
            } else {
                Notification.Desyntic.unknownError.sendNotification()
            }
        }
    }
    
    /// Create new estimate
    func create(estimate: Estimate.Create, by user: User) {
        networkManager.request(urlParams: NetworkConfigurations.estimateAdd.urlParams,
                               method: NetworkConfigurations.estimateAdd.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: estimate) { _, response, error in
            if let statusCode = response?.statusCode {
                switch statusCode {
                case 201:
                    Notification.Desyntic.estimateCreated.sendNotification()
                case 500:
                    Notification.Desyntic.estimateFailedCreated.sendNotification()
                default:
                    Notification.Desyntic.unknownError.sendNotification()
                }
            } else {
                Notification.Desyntic.unknownError.sendNotification()
            }
        }
    }
    
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
               status == 200{
                if let estimates = try? JSONDecoder().decode([Estimate.Summary].self, from: data) {
                    self.estimatesList = estimates
                    Notification.Desyntic.estimatesListDownload.sendNotification()
                } else {
                    Notification.Desyntic.unknownError.sendNotification()
                }
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
               let data = data {
                switch status {
                case 200:
                    if let estimate = try? JSONDecoder().decode(Estimate.Informations.self, from: data) {
                        self.estimateDetail = estimate
                        self.downloadPDF(of: id, by: user)
                    } else {
                        Notification.Desyntic.unknownError.sendNotification()
                    }
                case 404:
                    Notification.Desyntic.notFound.sendNotification(customMessage: "The estimate was not found!")
                default:
                    Notification.Desyntic.unknownError.sendNotification()
                }
            } else {
                Notification.Desyntic.unknownError.sendNotification()
            }
        }
    }
    
    // Update estimate
    func update(estimate: Estimate.Update, by user: User) {
        networkManager.request(urlParams: NetworkConfigurations.estimateUpdate.urlParams,
                               method: NetworkConfigurations.estimateUpdate.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: estimate) { _, response, error in
            if let statusCode = response?.statusCode {
                switch statusCode {
                case 200:
                    Notification.Desyntic.estimateUpdated.sendNotification()
                case 500:
                    Notification.Desyntic.estimateErrorUpdate.sendNotification()
                default:
                    Notification.Desyntic.unknownError.sendNotification()
                }
            } else {
                Notification.Desyntic.unknownError.sendNotification()
            }
        }
    }
    
    /// Export the estimate to an invoice
    func exportToInvoice(estimate: String, by user: User) {
        var params = NetworkConfigurations.estimateExportToInvoice.urlParams
        params.append(estimate)
        
        networkManager.request(urlParams: params,
                               method: NetworkConfigurations.estimateExportToInvoice.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: nil) { _, response, error in
            if let statusCode = response?.statusCode {
                switch statusCode {
                case 201:
                    Notification.Desyntic.estimateExportToInvoiceSuccess.sendNotification()
                case 404:
                    Notification.Desyntic.notFound.sendNotification(customMessage: "The estimate was not found")
                case 500:
                    Notification.Desyntic.estimateExportToInvoiceFailed.sendNotification()
                default:
                    Notification.Desyntic.unknownError.sendNotification()
                }
            } else {
                Notification.Desyntic.unknownError.sendNotification()
            }
        }
    }
    
    /// Download PDF
    func downloadPDF(of id: UUID, by user: User) {
        var params = NetworkConfigurations.estimatePDF.urlParams
        params.append("\(id)")
        networkManager.request(urlParams: params,
                               method: NetworkConfigurations.estimatePDF.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: nil) { [weak self] data, response, Error in
            if let self = self,
               let statusCode = response?.statusCode,
               statusCode == 200,
               let data = data {
                self.estimatePdf = data
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
}
