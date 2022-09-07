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
    
    // Product update
    @Published var productIsUpdated: Bool = false
    
    // Product create
    @Published var productIsCreated: Bool = false
    
    // MARK: Methods
    /// Getting all products
    func gettingProductList(for user: User?) {
        guard let user = user else { return }
        
        productManager.gettingProductList(for: user)
    }
    
    /// Update product
    func updateProduct(_ product: Product, by user: User?) {
        guard let user = user else { return }
        
        appController.setLoadingInProgress(withMessage: "Update in progress...")
        
        productManager.updateProduct(product, by: user)
    }
    
    /// Create product
    func createProduct(_ product: Product.Create, by user: User?) {
        guard let user = user else { return }
        
        appController.setLoadingInProgress(withMessage: "Creating in progress...")
        
        productManager.create(product, by: user)
    }
 
    // MARK: Initialization
    init(appController: AppController) {
        self.appController = appController
        
        // Configure notifications
        configureNotification(for: Notification.Desyntic.productsGettingList.notificationName)
        configureNotification(for: Notification.Desyntic.productsUpdateSuccess.notificationName)
        configureNotification(for: Notification.Desyntic.productsUpdateError.notificationName)
        configureNotification(for: Notification.Desyntic.productsCreateSuccess.notificationName)
        configureNotification(for: Notification.Desyntic.productsCreateError.notificationName)
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
           let notificationMessage = notification.userInfo?["message"] as? String {
            DispatchQueue.main.async {
                self.appController.resetLoadingInProgress()
                
                switch notificationName {
                case Notification.Desyntic.productsGettingList.notificationName:
                    self.products = self.productManager.products
                case Notification.Desyntic.productsUpdateSuccess.notificationName:
                    self.productIsUpdated = true
                case Notification.Desyntic.productsUpdateError.notificationName,
                    Notification.Desyntic.productsCreateError.notificationName:
                    self.appController.showAlertView(withMessage: notificationMessage, andTitle: "Error")
                case Notification.Desyntic.productsCreateSuccess.notificationName:
                    self.productIsCreated = true
                default: break
                }
            }
        }
    }
}
