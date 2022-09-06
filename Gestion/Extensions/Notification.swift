//
//  Notification.swift
//  Gestion
//
//  Created by Kevin Bertrand on 01/09/2022.
//

import Foundation

extension Notification {
    enum Desyntic: String {
        // General
        case unknownError = "An unknown error occurs... Try later!"
        
        // Login
        case loginSuccess = "Successfull login!"
        case loginWrongCredentials = "Your credentials are not correct!"
        
        // Revenues
        case revenuesSuccess = "The summary of revenues is downloaded!"
        case revenueThisMonth = "Getting this month success!"
        case revenueAllMonths = "All months are downloaded!"
        
        // Estimates
        case estimatesSummarySuccess = "Estimates for home page are downloaded!"
        case estimatesListDownload = "The list of estimates is downloaded!"
        case estimateGettingOne = "The details for the estimate are downloaded!"
        
        // Invoices
        case invoicesSummarySuccess = "Invoices for home page are downloaded!"
        case invoicesGettingOne = "The details for the invoice are downloaded!"
        case invoicesListDownloaded = "The list of invoices is downloaded!"
        case invoicesGettingReference = "The invoice reference is downloaded"
        case invoicesCreated = "The invoice is created"
        case invoicesFailedCreated = "Cannot create the invoice"
        
        // Client notifications
        case clientGettingList = "The list of clients is downloaded!"
        
        // Products notifications
        case productsGettingList = "Product list is downloaded!"
        
        // Getting the notification message
        var notificationMessage: String {
            return self.rawValue
        }
        
        /// Getting the name of the notification
        var notificationName: Notification.Name {
            return Notification.Name(rawValue: "\(self)")
        }
        
        // Send the notification throw the NotificationCenter
        func sendNotification(customMessage: String? = nil) {
            let notificationBuilder = Notification(name: notificationName, object: self, userInfo: ["name": self.notificationName, "message": customMessage != nil ? customMessage! : self.notificationMessage])
            NotificationCenter.default.post(notificationBuilder)
        }
    }
}
