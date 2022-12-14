//
//  InvoicesController.swift
//  Gestion
//
//  Created by Kevin Bertrand on 01/09/2022.
//

import Foundation
import SwiftUI
import WidgetKit

final class InvoicesController: ObservableObject {
    // MARK: Static
    static let emptySummaryInvoice: Invoice.Summary = .init(id: nil, client: .init(firstname: nil, lastname: nil, company: nil), reference: "", grandTotal: 0, status: .inCreation, limitPayementDate: Date(), isArchive: true)
    static let emptyUpdateInvoice: Invoice.Update = .init(id: UUID(uuid: UUID_NULL), reference: "", internalReference: "", object: "", totalServices: 0, totalMaterials: 0, totalDivers: 0, total: 0,  grandTotal: 0, status: .inCreation, facturationDate: ISO8601DateFormatter().string(from: Date()), comment: nil, products: [])
    static let emptyCreateInvoice: Invoice.Create = .init(reference: "", internalReference: "", object: "", totalServices: 0, totalMaterials: 0, totalDivers: 0, total: 0, grandTotal: 0, status: .inCreation, limitPayementDate: "\(ISO8601DateFormatter().string(from: Date()))", clientID: UUID(uuid: UUID_NULL), comment: nil, products: [])
    
    // MARK: Public
    // MARK: Properties
    // General properties
    var appController: AppController
    
    // Home page
    @Published var invoicesSummary: [Invoice.Summary] = []
    
    // Detail page
    @Published var selectedInvoice: Invoice.Informations
    @Published var invoicePDF: Data = Data()
    
    // Invoices list
    @Published var invoicesList: [Invoice.Summary] = []
    
    // New invoice
    @Published var newInvoiceReference: String = ""
    @Published var newInternalReference: String = ""
    @Published var successCreatingNewInvoice: Bool = false
    
    // Update invoice
    @Published var successUpdateInvoice: Bool = false
    
    // Is paied invoice
    @Published var isPayed: Bool = false
    
    // MARK: Methods
    /// Getting new invoice reference
    func gettingNewReference(for user: User?) {
        guard let user = user else { return }
        
        invoicesManager.gettingNewReference(for: user)
    }
    
    func gettingNewInternalReference(by user: User?, for domain: Domain) {
        guard let user = user else { return }
        
        invoicesManager.gettingNewInternalReference(by: user, for: domain)
    }
    
    /// Download invoices for home page
    func downloadInvoicesSummary(for user: User?) {
        guard let user = user else { return }
        
        invoicesManager.downloadThreeLatests(for: user)
    }
    
    /// Download all invoices summary
    func downloadAllInvoicesSummary(for user: User?) {
        guard let user = user else { return }
        
        invoicesManager.downloadAllInvoiceSummary(for: user)
    }
    
    /// Create new invoie
    func create(invoice: Invoice.Create, by user: User?) {
        guard let user = user else { return }
        
        appController.setLoadingInProgress(withMessage: "Creation in progress")
        
        invoicesManager.create(invoice: invoice, by: user)
    }
    
    /// Update invoice
    func update(invoice: Invoice.Update, by user: User?) {
        guard let user = user else { return }
        
        appController.setLoadingInProgress(withMessage: "Update in progress")
        
        invoicesManager.update(invoice: invoice, by: user)
    }
    
    /// Select invoice
    func selectInvoice(id: UUID?, by user: User?) {
        guard let user = user, let id = id else { return }
        
        appController.setLoadingInProgress(withMessage: "Downloading in progress... Please wait!")
        
        invoicesManager.downloadInvoiceDetails(id: id, for: user)
    }
    
    /// Unselect invoice
    func unselectInvoice() {
        selectedInvoice = InvoicesManager.emptyInvoiceDetail
    }
    
    /// Invoice is paied
    func invoiceIsPaied(by user: User?) {
        guard let user = user else { return }
        
        invoicesManager.isPaied(invoice: selectedInvoice.id, by: user)
    }
    
    // MARK: Initialization
    init(appController: AppController) {
        self.appController = appController
        selectedInvoice = InvoicesManager.emptyInvoiceDetail
        
        // Configure home notifications
        configureNotification(for: Notification.Desyntic.invoicesSummarySuccess.notificationName)
        
        // Configure new internal reference notifications
        configureNotification(for: Notification.Desyntic.internalReference.notificationName)
        
        // Configure details notification
        configureNotification(for: Notification.Desyntic.invoicesGettingOne.notificationName)
        
        // Confifure invoice list notificaitons
        configureNotification(for: Notification.Desyntic.invoicesListDownloaded.notificationName)
        configureNotification(for: Notification.Desyntic.invoiceIsPaied.notificationName)
        
        // Configure new invoice notification
        configureNotification(for: Notification.Desyntic.invoicesGettingReference.notificationName)
        configureNotification(for: Notification.Desyntic.invoicesCreated.notificationName)
        configureNotification(for: Notification.Desyntic.invoicesFailedCreated.notificationName)
        
        // Configure update invoice notification
        configureNotification(for: Notification.Desyntic.invoicesUpdateSuccess.notificationName)
        configureNotification(for: Notification.Desyntic.invoicesUpdateFailed.notificationName)
    }
    
    // MARK: Private
    // MARK: Properties
    private let invoicesManager = InvoicesManager()
    
    // MARK: Methods
    /// Configure notification
    private func configureNotification(for name: Notification.Name) {
        NotificationCenter.default.addObserver(self, selector: #selector(processNotification), name: name, object: nil)
    }
    
    /// Initialise all notification for this controller
    @objc private func processNotification(_ notification: Notification) {
        WidgetCenter.shared.reloadAllTimelines()
        if let notificationName = notification.userInfo?["name"] as? Notification.Name,
           let notificationMessage = notification.userInfo?["message"] as? String {
            DispatchQueue.main.async {
                self.appController.resetLoadingInProgress()
                
                switch notificationName {
                case Notification.Desyntic.invoicesSummarySuccess.notificationName:
                    self.invoicesSummary = self.invoicesManager.invoicesSummary
                case Notification.Desyntic.invoicesGettingOne.notificationName:
                    self.selectedInvoice = self.invoicesManager.invoiceDetail
                    self.invoicePDF = self.invoicesManager.invoicePDF
                case Notification.Desyntic.invoicesListDownloaded.notificationName:
                    self.invoicesList = self.invoicesManager.invoicesList
                case Notification.Desyntic.invoicesGettingReference.notificationName:
                    self.newInvoiceReference = notificationMessage
                case Notification.Desyntic.invoicesCreated.notificationName:
                    self.successCreatingNewInvoice = true
                case Notification.Desyntic.invoicesFailedCreated.notificationName:
                    self.appController.showAlertView(withMessage: notificationMessage, andTitle: "Error")
                case Notification.Desyntic.invoicesUpdateSuccess.notificationName:
                    self.successUpdateInvoice = true
                case Notification.Desyntic.invoicesUpdateFailed.notificationName:
                    self.appController.showAlertView(withMessage: notificationMessage, andTitle: "Error")
                case Notification.Desyntic.invoiceIsPaied.notificationName:
                    self.isPayed = true
                case Notification.Desyntic.internalReference.notificationName:
                    self.newInternalReference = notificationMessage
                default: break
                }
            }
        }
    }
}
