//
//  InvoiceStatus.swift
//  Gestion
//
//  Created by Kevin Bertrand on 31/08/2022.
//

import Foundation

enum InvoiceStatus: String, Codable, CaseIterable {
    case inCreation, sent, payed, overdue
}
