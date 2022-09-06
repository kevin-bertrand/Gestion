//
//  EstimateStatus.swift
//  Gestion
//
//  Created by Kevin Bertrand on 31/08/2022.
//

import Foundation

enum EstimateStatus: String, Codable, CaseIterable {
    case inCreation, sent, refused, late, accepted
}
