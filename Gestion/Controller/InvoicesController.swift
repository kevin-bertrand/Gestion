//
//  InvoicesController.swift
//  Gestion
//
//  Created by Kevin Bertrand on 01/09/2022.
//

import Foundation

final class InvoicesController: ObservableObject {
    // MARK: Public
    // MARK: Properties
    // General properties
    var appController: AppController
    
    // Home page
    @Published var invoicesSummary: [Invoice.Summary] = []
    
    // MARK: Methods
    /// Download invoices for home page
    func downloadInvoicesSummary(for user: User?) {
        guard let user = user else { return }
        
        invoicesManager.downloadThreeLatests(for: user)
    }
    
    // MARK: Initialization
    init(appController: AppController) {
        self.appController = appController
        
        // Configure home notifications
        configureNotification(for: Notification.Desyntic.invoicesSummarySuccess.notificationName)
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
        if let notificationName = notification.userInfo?["name"] as? Notification.Name,
           let notificationMessage = notification.userInfo?["message"] as? String {
            DispatchQueue.main.async {
                self.appController.resetLoadingInProgress()
                
                switch notificationName {
                case Notification.Desyntic.invoicesSummarySuccess.notificationName:
                    self.invoicesSummary = self.invoicesManager.invoicesSummary
                default: break
                }
            }
        }
    }
}
