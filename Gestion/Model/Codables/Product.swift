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
    
    func toInformation(with quantity: Double, and reduction: Double) -> Product.Informations {
        return .init(id: self.id, quantity: quantity,
                     reduction: reduction,
                     title: self.title,
                     unity: self.unity,
                     domain: self.domain,
                     productCategory: self.productCategory,
                     price: self.price)
    }
    
    struct CreateDocument: Codable {
        let productID: UUID
        let quantity: Double
        let reduction: Double
    }
    
    struct UpdateDocument: Codable {
        let productID: UUID
        let quantity: Double
        let reduction: Double
    }
    
    struct Informations: Codable, Equatable {
        let id: UUID
        var quantity: Double
        var reduction: Double
        let title: String
        let unity: String?
        let domain: Domain
        let productCategory: ProductCategory
        let price: Double
        
        func toUpdateDocuments() -> Product.UpdateDocument {
            return .init(productID: self.id, quantity: self.quantity, reduction: self.reduction)
        }
    }
    
    struct Create: Codable {
        var productCategory: ProductCategory
        var title: String
        var domain: Domain
        var unity: String
        var price: Double
    }
}
