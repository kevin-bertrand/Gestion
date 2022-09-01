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
        
        // Getting the notification message
        var notificationMessage: String {
            return self.rawValue
        }
        
        /// Getting the name of the notification
        var notificationName: Notification.Name {
            return Notification.Name(rawValue: "\(self)")
        }
        
        // Send the notification throw the NotificationCenter
        func sendNotification() {
            let notificationBuilder = Notification(name: notificationName, object: self, userInfo: ["name": self.notificationName, "message": self.notificationMessage])
            NotificationCenter.default.post(notificationBuilder)
        }
    }
}
