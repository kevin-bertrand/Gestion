//
//  Address.swift
//  Gestion
//
//  Created by Kevin Bertrand on 31/08/2022.
//

import Foundation

struct Address: Codable {
    let id: String
    let roadName: String
    let streetNumber: String
    let complement: String?
    let zipCode: String
    let city: String
    let country: String
    let latitude: Double
    let longitude: Double
    let comment: String
}
