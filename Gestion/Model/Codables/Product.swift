//
//  Product.swift
//  Gestion
//
//  Created by Kevin Bertrand on 31/08/2022.
//

import Foundation

struct Product: Codable {
    var id: UUID
    var productCategory: ProductCategory
    var title: String
    var domain: Domain
    var unity: String
    var price: Double
    
    struct CreateDocument: Codable {
        let productID: UUID
        let quantity: Double
    }
    
    struct UpdateDocument: Codable {
        let productID: UUID
        let quantity: Double
    }
    
    struct Informations: Codable, Equatable {
        let id: UUID
        let quantity: Double
        let title: String
        let unity: String?
        let domain: Domain
        let productCategory: ProductCategory
        let price: Double
    }
    
    struct Create: Codable {
        var productCategory: ProductCategory
        var title: String
        var domain: Domain
        var unity: String
        var price: Double
    }
}
