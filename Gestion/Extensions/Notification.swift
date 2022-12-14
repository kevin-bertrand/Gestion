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
        case notAuthorized = "You are not authorized to perform this action. Ask to an administrator!"
        case notFound = "The component was not found!"
        case lateInvoice = "The invoice is late"
        
        // User
        case loginSuccess = "Successfull login!"
        case loginWrongCredentials = "Your credentials are not correct!"
        case userUpdateSuccess = "The user is successfully updated!"
        case userUpdatePasswordError = "The update failed"
        case userUpdatePasswordSuccess = "The password is successfully updated"
        case userUpdatePictureSuccess = "The picture is successfully updated"
        case userUpdatePictureError = "The picture cannot be updated!"
        case userGettingPicture = "The picture is changed"
        
        // Revenues
        case revenuesSuccess = "The summary of revenues is downloaded!"
        case revenueThisMonth = "Getting this month success!"
        case revenueAllMonths = "All months are downloaded!"
        
        // Internal references
        case internalReference = "Tetting internal reference success"
        
        // Estimates
        case estimatesSummarySuccess = "Estimates for home page are downloaded!"
        case estimatesListDownload = "The list of estimates is downloaded!"
        case estimateGettingOne = "The details for the estimate are downloaded!"
        case estimateGettingReference = "The estimate reference is downloaded"
        case estimateCreated = "The estimate is created"
        case estimateFailedCreated = "Cannot create the estimate"
        case estimateUpdated = "The estimate is updated"
        case estimateErrorUpdate = "The estimate cannot be updated"
        case estimateExportToInvoiceSuccess = "The export is a success"
        case estimateExportToInvoiceFailed = "The export failed"
        
        // Invoices
        case invoicesSummarySuccess = "Invoices for home page are downloaded!"
        case invoicesGettingOne = "The details for the invoice are downloaded!"
        case invoicesListDownloaded = "The list of invoices is downloaded!"
        case invoicesGettingReference = "The invoice reference is downloaded"
        case invoicesCreated = "The invoice is created"
        case invoicesFailedCreated = "Cannot create the invoice"
        case invoicesUpdateSuccess = "The invoice is updated"
        case invoicesUpdateFailed = "The invoice update failed"
        case invoiceIsPaied = "The invoice is paied"
        
        // Client notifications
        case clientGettingList = "The list of clients is downloaded!"
        case clientUpdated = "The client is updated"
        case clientUpdateError = "An error occurs during the client update"
        case clientCreateSuccess = "The client is created"
        
        // Products notifications
        case productsGettingList = "Product list is downloaded!"
        case productsUpdateSuccess = "The product is updated"
        case productsUpdateError = "The product cannot be update"
        case productsCreateSuccess = "The new product is created"
        case productsCreateError = "The new product cannot be created!"
        
        // Payment notifications
        case paymentGettingList = "Payment list downloaded"
        case paymentUpdateSuccess = "The update of the payment is a success"
        case paymentUpdateError = "The update of the payment could not be done!"
        case paymentCreationSuccess = "The new payment is created"
        case paymentCreationError = "The new payment cannot be created!"
        
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
