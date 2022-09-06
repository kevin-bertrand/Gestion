//
//  Product.swift
//  Gestion
//
//  Created by Kevin Bertrand on 31/08/2022.
//

import Foundation

struct Product: Codable {
    let id: UUID
    let productCategory: ProductCategory
    let title: String
    let domain: Domain
    let unity: String
    let price: Double
    
    struct CreateDocument: Codable {
        let id: UUID
        let productCategory: ProductCategory
        let title: String
        let domain: Domain
        let unity: String
        let price: Double
        let quantity: Double
    }
    
    struct Create: Codable {
        let productID: UUID
        let quantity: Double
    }
    
    struct Update: Codable {
        let productEstimateID: UUID?
        let productID: UUID
        let quantity: Double
    }
    
    struct Informations: Codable {
        let quantity: Double
        let title: String
        let unity: String?
        let domain: Domain
        let productCategory: ProductCategory
        let price: Double
    }
}
