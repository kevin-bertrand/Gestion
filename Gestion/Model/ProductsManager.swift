//
//  ProductsManager.swift
//  Gestion
//
//  Created by Kevin Bertrand on 06/09/2022.
//

import Foundation

final class ProductManager {
    // MARK: Public
    // MARK: Properties
    var products: [Product] = []
    
    // MARK: Methods
    /// Getting all products
    func gettingProductList(for user: User) {
        networkManager.request(urlParams: NetworkConfigurations.productGetList.urlParams,
                               method: NetworkConfigurations.productGetList.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: nil) { [weak self] data, response, error in
            if let self = self,
               let statusCode = response?.statusCode,
               statusCode == 200,
               let data = data,
               let products = try? JSONDecoder().decode([Product].self, from: data) {
                self.products = products
                Notification.Desyntic.productsGettingList.sendNotification()
            } else {
                Notification.Desyntic.unknownError.sendNotification()
            }
        }
    }
    
    /// Update product
    func updateProduct(_ product: Product, by user: User) {
        var params = NetworkConfigurations.productUpdate.urlParams
        params.append("\(product.id)")
        
        networkManager.request(urlParams: params,
                               method: NetworkConfigurations.productUpdate.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: product) { _, response, error in
            if let statusCode = response?.statusCode {
                switch statusCode {
                case 200:
                    Notification.Desyntic.productsUpdateSuccess.sendNotification()
                case 401:
                    Notification.Desyntic.productsUpdateError.sendNotification()
                default:
                    Notification.Desyntic.unknownError.sendNotification()
                }
            } else {
                Notification.Desyntic.unknownError.sendNotification()
            }
        }
    }
    
    /// Create product
    func create(_ product: Product.Create, by user: User) {
        networkManager.request(urlParams: NetworkConfigurations.productAdd.urlParams,
                               method: NetworkConfigurations.productAdd.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: product) { _, response, error in
            if let statusCode = response?.statusCode {
                switch statusCode {
                case 201:
                    Notification.Desyntic.productsCreateSuccess.sendNotification()
                case 401:
                    Notification.Desyntic.productsCreateError.sendNotification()
                default:
                    Notification.Desyntic.unknownError.sendNotification()
                }
            } else {
                Notification.Desyntic.unknownError.sendNotification()
            }
        }
    }
    
    // MARK: Initialization
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    // MARK: Private
    // MARK: Properties
    private let networkManager: NetworkManager
}
