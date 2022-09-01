//
//  Revenues.swift
//  Gestion
//
//  Created by Kevin Bertrand on 01/09/2022.
//

import Foundation

struct Revenues: Codable {
    let year: Double
    let month: Double
    
    struct Year: Codable {
        let id: UUID?
        let totalDivers: Double
        let totalServices: Double
        let totalMaterials: Double
        let grandTotal: Double
        let year: Int
    }
    
    struct Month: Codable, Identifiable {
        let id: UUID
        let totalDivers: Double
        let totalServices: Double
        let totalMaterials: Double
        let grandTotal: Double
        let month: Int
        let year: Int
    }
}
