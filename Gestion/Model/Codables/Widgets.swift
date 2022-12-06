//
//  Widgets.swift
//  Gestion
//
//  Created by Kevin Bertrand on 05/12/2022.
//

import Foundation

struct Widgets: Codable {
    let yearRevenues: Double
    let monthRevenues: Double
    let estimatesInCreation: Int
    let estimatesInWaiting: Int
    let invoiceInWaiting: Int
    let invoiceUnPaid: Int
}
