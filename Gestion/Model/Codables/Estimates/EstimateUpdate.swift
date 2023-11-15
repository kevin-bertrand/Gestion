//
//  EstimateUpdate.swift
//  Gestion
//
//  Created by Kevin Bertrand on 11/12/23.
//

import Foundation

struct EstimateUpdate: Codable {
    // MARK: Properties
    let id: UUID?
    let reference: Reference
    let internalReference: InternalReference
    let clientId: UUID
    let object: String
    let creationDate: Date
    let sendingDate: Date?
    let validityDate: Date?
    let validationDate: Date?
    let refusedDate: Date?
    let comment: String?
    let status: EstimateStatus
    let products: [Product.UpdateDocument]
    let options: [Options.Informations]
    let amountServices: Int
    let amountMaterial: Int
    let amountDivers: Int
    let total: Int
    
    // MARK: Coding keys
    private enum CodingKeys: String, CodingKey {
        case internalReference = "internal-reference"
        case clientId = "client-id"
        case creationDate = "creation-date"
        case sendingDate = "sending-date"
        case validityDate = "validity-date"
        case validationDate = "validation-date"
        case refusedDate = "refused-date"
        case amountServices = "amount-services"
        case amountMaterial = "amount-material"
        case amountDivers = "amount-divers"
        case id, reference, object, comment, status, products, options, total
    }
}
