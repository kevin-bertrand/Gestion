//
//  ClientController.swift
//  Gestion
//
//  Created by Kevin Bertrand on 06/09/2022.
//

import Foundation

final class ClientController: ObservableObject {
    // MARK: Static
    static let emptyClientInfo: Client.Informations = .init(id: nil, firstname: nil, lastname: nil, company: nil, phone: "", email: "", personType: .company, gender: .notDetermined, siret: nil, tva: nil, address: Address(id: "", roadName: "", streetNumber: "", complement: nil, zipCode: "", city: "", country: "", latitude: 0, longitude: 0, comment: nil))
    
    // MARK: Public
    // MARK: Properties
    // General properties
    var appController: AppController
    
    // Client list
    @Published var clients: [Client.Informations] = []
    @Published var searchingField: String = ""
    
    // MARK: Methods
    /// Getting client list
    func gettingList(for user: User?) {
        guard let user = user else { return }
        
        clientManager.getList(for: user)
    }
    
    // MARK: Initialization
    init(appController: AppController) {
        self.appController = appController
        
        // Configure notifications
        configureNotification(for: Notification.Desyntic.clientGettingList.notificationName)
    }
    
    // MARK: Private
    // MARK: Properties
    private let clientManager = ClientManager()
    
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
                case Notification.Desyntic.clientGettingList.notificationName:
                    self.clients =  self.clientManager.clients
                default: break
                }
            }
        }
    }
}
