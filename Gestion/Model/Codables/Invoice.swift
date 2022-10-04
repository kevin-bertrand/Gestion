//
//  Invoice.swift
//  Gestion
//
//  Created by Kevin Bertrand on 31/08/2022.
//

import Foundation

struct Invoice {
    struct Create: Codable {
        var reference: String
        var internalReference: String
        var object: String
        var totalServices: Double
        var totalMaterials: Double
        var totalDivers: Double
        var total: Double
        var grandTotal: Double
        var status: InvoiceStatus
        var limitPayementDate: String
        var clientID: UUID
        var comment: String?
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
        var grandTotal: Double
        var status: InvoiceStatus
        var limitPayementDate: String?
        var facturationDate: String
        var paymentID: UUID?
        var comment: String?
        var limitMaximumInterests: String?
        var maxInterests: Double?
        var products: [Product.UpdateDocument]
    }
    
    struct Summary: Codable {
        let id: UUID?
        let client: Client.Summary
        let reference: String
        let grandTotal: Double
        let status: InvoiceStatus
        let limitPayementDate: Date
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
        let grandTotal: Double
        let status: InvoiceStatus
        let limitPayementDate: Date
        let facturationDate: Date
        let delayDays: Int
        let totalDelay: Double
        let client: Client.Informations
        let products: [Product.Informations]
        let isArchive: Bool
        let comment: String?
        let payment: Payment?
        let limitMaximumInterests: Date?
        let maxInterests: Double?
        
        func toUpdate() -> Invoice.Update {
            return .init(id: self.id, reference:
                            self.reference,
                         internalReference: self.internalReference,
                         object: self.object,
                         totalServices: self.totalServices,
                         totalMaterials: self.totalMaterials,
                         totalDivers: self.totalDivers,
                         total: self.total,
                         grandTotal: self.grandTotal,
                         status: self.status,
                         limitPayementDate: ISO8601DateFormatter().string(from: limitPayementDate),
                         facturationDate: ISO8601DateFormatter().string(from: facturationDate),
                         paymentID: payment?.id,
                         comment: comment,
                         limitMaximumInterests: ISO8601DateFormatter().string(from: limitMaximumInterests ?? Date()),
                         maxInterests: maxInterests,
                         products: self.products.map({$0.toUpdateDocuments()}))
        }
    }
}
