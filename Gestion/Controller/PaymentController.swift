//
//  PaymentController.swift
//  Gestion
//
//  Created by Kevin Bertrand on 07/09/2022.
//

import Foundation

final class PaymentController: ObservableObject {
    // MARK: Public
    // MARK: Properties
    // General properties
    var appController: AppController
    
    // Payment listing
    @Published var payments: [Payment] = []
    
    // MARK: Methods
    /// Get all methods
    func gettingAllMethods(by user: User?) {
        guard let user = user else { return }
        
        appController.setLoadingInProgress(withMessage: "Downloading payment list...")
        
        paymentManager.gettingPaymentList(by: user)
    }
    
    // MARK: Initialization
    init(appController: AppController) {
        self.appController = appController
        
        // Configure notifications
        configureNotification(for: Notification.Desyntic.paymentGettingList.notificationName)
    }
    
    // MARK: Private
    // MARK: Properties
    private let paymentManager = PaymentManager()
    
    // MARK: Methods
    /// Configure notifications
    private func configureNotification(for name: Notification.Name) {
        NotificationCenter.default.addObserver(self, selector: #selector(processNotification), name: name, object: nil)
    }
    
    /// Initialise all notifications for this controller
    @objc private func processNotification(_ notification: Notification) {
        if let notificationName = notification.userInfo?["name"] as? Notification.Name,
           let _ = notification.userInfo?["message"] as? String {
            DispatchQueue.main.async {
                self.appController.resetLoadingInProgress()
                
                switch notificationName {
                case Notification.Desyntic.paymentGettingList.notificationName:
                    self.payments = self.paymentManager.payments
                default: break
                }
            }
        }
    }
}
