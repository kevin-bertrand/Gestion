//
//  ProductsController.swift
//  Gestion
//
//  Created by Kevin Bertrand on 06/09/2022.
//

import Foundation

final class ProductsController: ObservableObject {
    // MARK: Public
    // MARK: Properties
    // General properties
    var appController: AppController
    
    // Product list
    @Published var products: [Product] = []
    
    // MARK: Methods
    /// Getting all products
    func gettingProductList(for user: User?) {
        guard let user = user else { return }
        
        productManager.gettingProductList(for: user)
    }
    
    // MARK: Initialization
    init(appController: AppController) {
        self.appController = appController
        
        // Configure notifications
        configureNotification(for: Notification.Desyntic.productsGettingList.notificationName)
    }
    
    // MARK: Private
    // MARK: Properties
    private let productManager = ProductManager()
    
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
                case Notification.Desyntic.productsGettingList.notificationName:
                    self.products = self.productManager.products
                default: break
                }
            }
        }
    }
}
