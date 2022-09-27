//
//  EstimatesController.swift
//  Gestion
//
//  Created by Kevin Bertrand on 01/09/2022.
//

import Foundation
import SwiftUI

final class EstimatesController: ObservableObject {
    // MARK: Static
    static let emptyCreateEstimate: Estimate.Create = .init(reference: "", internalReference: "", object: "", totalServices: 0, totalMaterials: 0, totalDivers: 0, total: 0, status: .inCreation, clientID: UUID(uuid: UUID_NULL), products: [])
    static let emptyUpdateEstimate: Estimate.Update = .init(id: UUID(uuid: UUID_NULL), reference: "", internalReference: "", object: "", totalServices: 0, totalMaterials: 0, totalDivers: 0, total: 0, status: .inCreation, products: [])
    
    // MARK: Public
    // MARK: Properties
    // General properties
    var appController: AppController
    
    // Home page
    @Published var estimatesSummary: [Estimate.Summary] = []
    
    // Estimate list
    @Published var estimatesList: [Estimate.Summary] = []
    
    // Detail page
    @Published var selectedEstimate: Estimate.Informations = EstimatesManager.emptyDetail
    @Published var estimateIsExportedToInvoice: Bool = false
    @Published var estimatePdf: Data = Data()
    
    // New estimate page
    @Published var newEstimateReference: String = ""
    @Published var newEstimateCreateSuccess: Bool = false
    
    // Update estimate page
    @Published var updateEstimateSuccess: Bool = false
    
    // MARK: Methods
    /// Download estimates for home page
    func downloadEstimatesSummary(for user: User?) {
        guard let user = user else { return }
        
        estimatesManager.downloadThreeLatests(for: user)
    }
    
    /// Download all estimates
    func downloadAllEstimatesSummary(for user: User?) {
        guard let user = user else { return }
        
        estimatesManager.downloadAllEstimates(for: user)
    }
    
    /// Download estimate detail
    func downloadEstimateDetail(id: UUID?, by user: User?) {
        guard let user = user, let id = id else { return }
        
        appController.setLoadingInProgress(withMessage: "Downloading in progress... Please wait!")
        
        estimatesManager.downloadEstimateDetails(id: id, for: user)
    }
    
    /// Getting new estimate reference
    func gettingNewReference(by user: User?) {
        guard let user = user else { return }
        
        estimatesManager.gettingNewReference(by: user)
    }
    
    /// Create new estimate
    func create(estimate: Estimate.Create, by user: User?) {
        guard let user = user else { return }
        
        appController.setLoadingInProgress(withMessage: "Creation in progress")
        
        estimatesManager.create(estimate: estimate, by: user)
    }
    
    /// Update estimate
    func update(estimate: Estimate.Update, by user: User?) {
        guard let user = user else { return }
        
        appController.setLoadingInProgress(withMessage: "Update in progress")
        
        estimatesManager.update(estimate: estimate, by: user)
    }
    
    /// Export to an invoice
    func exportToInvoice(by user: User?) {
        guard let user = user, selectedEstimate.reference != "" else { return }
        
        appController.setLoadingInProgress(withMessage: "Exporting to an invoice...")
        
        estimatesManager.exportToInvoice(estimate: selectedEstimate.reference, by: user)
    }
    
    // MARK: Initialization
    init(appController: AppController) {
        self.appController = appController
        
        // Configure home notifications
        configureNotification(for: Notification.Desyntic.estimatesSummarySuccess.notificationName)
        
        // Configure list notification
        configureNotification(for: Notification.Desyntic.estimatesListDownload.notificationName)
        
        // Configure estimate details notifications
        configureNotification(for: Notification.Desyntic.estimateGettingOne.notificationName)
        configureNotification(for: Notification.Desyntic.estimateExportToInvoiceFailed.notificationName)
        configureNotification(for: Notification.Desyntic.estimateExportToInvoiceSuccess.notificationName)
        
        // Configure new estimate notification
        configureNotification(for: Notification.Desyntic.estimateCreated.notificationName)
        configureNotification(for: Notification.Desyntic.estimateFailedCreated.notificationName)
        configureNotification(for: Notification.Desyntic.estimateGettingReference.notificationName)
        
        // Configure update estimate
        configureNotification(for: Notification.Desyntic.estimateErrorUpdate.notificationName)
        configureNotification(for: Notification.Desyntic.estimateUpdated.notificationName)
    }
    
    // MARK: Private
    // MARK: Properties
    private let estimatesManager = EstimatesManager()
    
    // MARK: Methods
    /// Configure notification
    private func configureNotification(for name: Notification.Name) {
        NotificationCenter.default.addObserver(self, selector: #selector(processNotification), name: name, object: nil)
    }
    
    /// Initialise all notification for this controller
    @objc private func processNotification(_ notification: Notification) {
        if let notificationName = notification.userInfo?["name"] as? Notification.Name,
           let notificationMessage = notification.userInfo?["message"] as? String {
            DispatchQueue.main.async {
                self.appController.resetLoadingInProgress()
                
                switch notificationName {
                case Notification.Desyntic.estimatesSummarySuccess.notificationName:
                    self.estimatesSummary = self.estimatesManager.estimatesSummary
                case Notification.Desyntic.estimatesListDownload.notificationName:
                    self.estimatesList = self.estimatesManager.estimatesList
                case Notification.Desyntic.estimateGettingOne.notificationName:
                    self.selectedEstimate = self.estimatesManager.estimateDetail
                    self.estimatePdf = self.estimatesManager.estimatePdf
                case Notification.Desyntic.estimateGettingReference.notificationName:
                    self.newEstimateReference = notificationMessage
                case Notification.Desyntic.estimateCreated.notificationName:
                    self.newEstimateCreateSuccess = true
                case Notification.Desyntic.estimateFailedCreated.notificationName,
                    Notification.Desyntic.estimateErrorUpdate.notificationName,
                    Notification.Desyntic.estimateExportToInvoiceFailed.notificationName:
                    self.appController.showAlertView(withMessage: notificationMessage, andTitle: "Error")
                case Notification.Desyntic.estimateUpdated.notificationName:
                    self.updateEstimateSuccess = true
                case Notification.Desyntic.estimateExportToInvoiceSuccess.notificationName :
                    self.estimateIsExportedToInvoice = true
                default: break
                }
            }
        }
    }
}
