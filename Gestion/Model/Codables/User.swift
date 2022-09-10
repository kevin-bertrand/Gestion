//
//  User.swift
//  Gestion
//
//  Created by Kevin Bertrand on 01/09/2022.
//

import Foundation

struct User: Codable {
    let id: UUID
    let phone: String
    let gender: Gender
    let position: Position
    let lastname: String
    let role: String
    let firstname: String
    let email: String
    let token: String
    let permissions: String
    let address: Address
    
    struct Login: Codable {
        let email: String
        let password: String
    }
    
    struct Update: Codable {
        let id: UUID
        var firstname: String
        var lastname: String
        var phone: String
        var email: String
        var gender: Gender
        var position: Position
        var role: String
        var address: Address.Create        
    }
    
    func toUpdate() -> User.Update {
        return .init(id: self.id, firstname: self.firstname, lastname: self.lastname, phone: self.phone, email: self.email, gender: self.gender, position: self.position, role: self.role, address: self.address.toCreate())
    }
}
