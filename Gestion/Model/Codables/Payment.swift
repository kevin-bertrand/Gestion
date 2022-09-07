//
//  Payment.swift
//  Gestion
//
//  Created by Kevin Bertrand on 07/09/2022.
//

import Foundation

struct Payment: Codable {
    let id: UUID
    var title: String
    var iban: String
    var bic: String
}
