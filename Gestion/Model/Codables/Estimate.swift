//
//  Estimate.swift
//  Gestion
//
//  Created by Kevin Bertrand on 31/08/2022.
//

import Foundation

struct Estimate {
    struct Create: Codable {
        var reference: String
        var internalReference: String
        var object: String
        var totalServices: Double
        var totalMaterials: Double
        var totalDivers: Double
        var total: Double
        var status: EstimateStatus
        var limitValidifyDate: String?
        var clientID: UUID
        var products: [Product.CreateDocument]
    }
    
    struct Update: Codable {
        var id: UUID
        var reference: String
        var internalReference: String
        var object: String
        var totalServices: Double
        var totalMaterials: Double
        var totalDivers: Double
        var total: Double
        var status: EstimateStatus
        var limitValidifyDate: String?
        var products: [Product.UpdateDocument]
    }
    
    struct Summary: Codable {
        let id: UUID?
        let client: Client.Summary
        let reference: String
        let total: Double
        let status: EstimateStatus
        let limitValidifyDate: Date
        let isArchive: Bool
    }
    
    struct Informations: Codable {
        let id: UUID
        let reference: String
        let internalReference: String
        let object: String
        let totalServices: Double
        let totalMaterials: Double
        let totalDivers: Double
        let total: Double
        let status: EstimateStatus
        let limitValidityDate: Date
        let isArchive: Bool
        let client: Client.Informations
        let products: [Product.Informations]
        
        func toUpdate() -> Estimate.Update {
            return .init(id: self.id,
                         reference: self.reference,
                         internalReference: self.internalReference,
                         object: self.object,
                         totalServices: self.totalServices,
                         totalMaterials: self.totalMaterials,
                         totalDivers: self.totalDivers,
                         total: self.total,
                         status: self.status,
                         products: self.products.map({$0.toUpdateDocuments()}))
        }
    }
}
