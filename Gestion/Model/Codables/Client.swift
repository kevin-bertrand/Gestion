//
//  Client.swift
//  Gestion
//
//  Created by Kevin Bertrand on 31/08/2022.
//

import Foundation

struct Client: Codable {
    struct Informations: Codable {
        let firstname: String?
        let lastname: String?
        let company: String?
        let phone: String
        let email: String
        let personType: PersonType
        let gender: Gender?
        let siret: String?
        let tva: String?
        let address: Address
    }
    
    struct Summary: Codable {
        let firstname: String?
        let lastname: String?
        let company: String?
    }
}
