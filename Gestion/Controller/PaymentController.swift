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
    
    // Payment update
    @Published var paymentIsUpdated: Bool = false
    
    // Payment creation
    @Published var paymentIsCreate: Bool = false
    
    // MARK: Methods
    /// Get all methods
    func gettingAllMethods(by user: User?) {
        guard let user = user else { return }
        appController.setLoadingInProgress(withMessage: "Downloading payment list...")
        paymentManager.gettingPaymentList(by: user)
    }
    
    /// Update payment method
    func update(method: Payment, by user: User?) {
        guard let user = user else { return }
        appController.setLoadingInProgress(withMessage: "Updating in progress...")
        paymentManager.update(method: method, by: user)
    }
    
    /// Create payment
    func create(method: Payment.Create, by user: User?) {
        guard let user = user else { return }
        appController.setLoadingInProgress(withMessage: "Creation in progress...")
        paymentManager.create(method: method, by: user)
    }
    
    // MARK: Initialization
    init(appController: AppController) {
        self.appController = appController
        
        // Configure notifications
        configureNotification(for: Notification.Desyntic.paymentGettingList.notificationName)
        configureNotification(for: Notification.Desyntic.paymentUpdateError.notificationName)
        configureNotification(for: Notification.Desyntic.paymentUpdateSuccess.notificationName)
        configureNotification(for: Notification.Desyntic.paymentCreationError.notificationName)
        configureNotification(for: Notification.Desyntic.paymentCreationSuccess.notificationName)
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
           let notificationMessage = notification.userInfo?["message"] as? String {
            DispatchQueue.main.async {
                self.appController.resetLoadingInProgress()
                
                switch notificationName {
                case Notification.Desyntic.paymentGettingList.notificationName:
                    self.payments = self.paymentManager.payments
                case Notification.Desyntic.paymentUpdateSuccess.notificationName:
                    self.paymentIsUpdated = true
                case Notification.Desyntic.paymentUpdateError.notificationName,
                    Notification.Desyntic.paymentCreationError.notificationName:
                    self.appController.showAlertView(withMessage: notificationMessage, andTitle: "Error")
                case Notification.Desyntic.paymentCreationSuccess.notificationName:
                    self.paymentIsCreate = true
                default: break
                }
            }
        }
    }
}
