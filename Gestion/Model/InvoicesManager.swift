//
//  InvoicesManager.swift
//  Gestion
//
//  Created by Kevin Bertrand on 01/09/2022.
//

import Foundation

final class InvoicesManager {
    // MARK: Static
    static let emptyInvoiceDetail = Invoice.Informations(id: UUID(uuid: UUID_NULL), reference: "", internalReference: "", object: "", totalServices: 0, totalMaterials: 0, totalDivers: 0, total: 0, grandTotal: 0, status: .inCreation, limitPayementDate: Date(), facturationDate: Date(), delayDays: 0, totalDelay: 0.0, client: .init(id: nil, firstname: "", lastname: "", company: "", phone: "", email: "", personType: .company, gender: .man, siret: "", tva: "", address: Address(id: "", roadName: "", streetNumber: "", complement: "", zipCode: "", city: "", country: "", latitude: 0, longitude: 0, comment: "")), products: [], isArchive: true, comment: nil, payment: nil, limitMaximumInterests: nil, maxInterests: nil)
    
    // MARK: Public
    // MARK: Properties
    var invoicesSummary: [Invoice.Summary] = []
    var invoiceDetail: Invoice.Informations = InvoicesManager.emptyInvoiceDetail
    var invoicesList: [Invoice.Summary] = []
    var invoicePDF: Data = Data()
    
    // MARK: Methods
    /// Getting new invoice reference
    func gettingNewReference(for user: User) {
        networkManager.request(urlParams: NetworkConfigurations.invoiceGetReference.urlParams,
                               method: NetworkConfigurations.invoiceGetReference.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: nil) { data, response, error in
            if let statusCode = response?.statusCode,
               let data = data,
               statusCode == 200,
               let reference = try? JSONDecoder().decode(String.self, from: data) {
                Notification.Desyntic.invoicesGettingReference.sendNotification(customMessage: reference)
            } else {
                Notification.Desyntic.unknownError.sendNotification()
            }
        }
    }
    
    /// Getting new internal reference
    func gettingNewInternalReference(by user: User, for domain: Domain) {
        var params = NetworkConfigurations.internalReference.urlParams
        params.append(domain.rawValue)
        
        networkManager.request(urlParams: params,
                               method: NetworkConfigurations.internalReference.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: nil) { data, response, error in
            if let statusCode = response?.statusCode,
               statusCode == 200,
               let data = data,
               let reference = try? JSONDecoder().decode(String.self, from: data) {
                Notification.Desyntic.internalReference.sendNotification(customMessage: reference)
            } else {
                Notification.Desyntic.unknownError.sendNotification()
            }
        }
    }
    
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
    
    /// Download all invoices summary
    func downloadAllInvoiceSummary(for user: User) {
        networkManager.request(urlParams: NetworkConfigurations.invoiceGetList.urlParams,
                               method: NetworkConfigurations.invoiceGetList.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: nil) { [weak self] data, response, error in
            if let self = self,
               let statusCode = response?.statusCode,
               statusCode == 200,
               let data = data,
               let invoices = try? JSONDecoder().decode([Invoice.Summary].self, from: data) {
                self.invoicesList = invoices
                Notification.Desyntic.invoicesListDownloaded.sendNotification()
            } else {
                Notification.Desyntic.unknownError.sendNotification()
            }
        }
    }
    
    /// Download invoice details
    func downloadInvoiceDetails(id: UUID, for user: User) {
        var params = NetworkConfigurations.invoiceGetOne.urlParams
        params.append("\(id)")
        networkManager.request(urlParams: params,
                               method: NetworkConfigurations.invoiceGetOne.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: nil) { [weak self] data, response, error in
            if let self = self,
               let statusCode = response?.statusCode {
                switch statusCode {
                case 200:
                    if let data = data,
                       let invoice = try? JSONDecoder().decode(Invoice.Informations.self, from: data) {
                        self.invoiceDetail = invoice
                        self.invoiceDetail.limitMaximumInterests = self.invoiceDetail.limitMaximumInterests ?? Date()
                        self.downloadPDF(of: invoice.reference, by: user)
                    } else {
                        Notification.Desyntic.unknownError.sendNotification()
                    }
                case 404:
                    Notification.Desyntic.notFound.sendNotification(customMessage: "The invoice was not found")
                default:
                    Notification.Desyntic.unknownError.sendNotification()
                }
            } else {
                Notification.Desyntic.unknownError.sendNotification()
            }
        }
    }
    
    /// Create a new invoice
    func create(invoice: Invoice.Create, by user: User) {
        networkManager.request(urlParams: NetworkConfigurations.invoiceAdd.urlParams,
                               method: NetworkConfigurations.invoiceAdd.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: invoice) { _, response, error in
            if let statusCode = response?.statusCode {
                switch statusCode {
                case 201:
                    Notification.Desyntic.invoicesCreated.sendNotification()
                case 500:
                    Notification.Desyntic.invoicesFailedCreated.sendNotification()
                default:
                    Notification.Desyntic.unknownError.sendNotification()
                }
            } else {
                Notification.Desyntic.unknownError.sendNotification()
            }
        }
    }
    
    /// Updating an invoice
    func update(invoice: Invoice.Update, by user: User) {
        networkManager.request(urlParams: NetworkConfigurations.invoiceUpdate.urlParams,
                               method: NetworkConfigurations.invoiceUpdate.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: invoice) {  _, response, error in
            if let statusCode = response?.statusCode {
                switch statusCode {
                case 200:
                    Notification.Desyntic.invoicesUpdateSuccess.sendNotification()
                case 500:
                    Notification.Desyntic.invoicesUpdateFailed.sendNotification()
                default:
                    Notification.Desyntic.unknownError.sendNotification()
                }
            } else {
                Notification.Desyntic.unknownError.sendNotification()
            }
        }
    }
    
    /// Download PDF
    func downloadPDF(of reference: String, by user: User) {
        var params = NetworkConfigurations.invoicePDF.urlParams
        params.append("\(reference)")
        networkManager.request(urlParams: params,
                               method: NetworkConfigurations.invoicePDF.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: nil) { [weak self] data, response, Error in
            if let self = self,
               let status = response?.statusCode,
               status == 200,
               let data = data {
                self.invoicePDF = data
                Notification.Desyntic.invoicesGettingOne.sendNotification()
            } else {
                Notification.Desyntic.unknownError.sendNotification()
            }
        }
    }
    
    /// Invoice is paied
    func isPaied(invoice: UUID, by user: User) {
        var params = NetworkConfigurations.invoicePaied.urlParams
        params.append("\(invoice)")
        networkManager.request(urlParams: params,
                               method: NetworkConfigurations.invoicePaied.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: nil) { _, response, _ in
            if let status = response?.statusCode,
               status == 200 {
                Notification.Desyntic.invoiceIsPaied.sendNotification()
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
