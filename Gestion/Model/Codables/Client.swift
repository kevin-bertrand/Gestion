//
//  Client.swift
//  Gestion
//
//  Created by Kevin Bertrand on 31/08/2022.
//

import Foundation

struct Client: Codable {
    let id: UUID
    let firstname: String?
    let lastname: String?
    let company: String?
    let phone: String
    let email: String
    let personType: PersonType
    let gender: Gender?
    let address: Address.Id
    let siret: String?
    let tva: String?
    
    struct Informations: Codable, Equatable {
        static func == (lhs: Client.Informations, rhs: Client.Informations) -> Bool {
            lhs.id == rhs.id
        }
        
        let id: UUID?
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
    
    struct Update: Codable {
        var id: UUID
        var firstname: String
        var lastname: String
        var company: String
        var phone: String
        var email: String
        var personType: PersonType
        var gender: Gender
        var siret: String
        var tva: String
        var address: Address.New
    }
}
