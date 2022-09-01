//
//  User.swift
//  Gestion
//
//  Created by Kevin Bertrand on 01/09/2022.
//

import Foundation

struct User: Codable {
    let phone: String
    let gender: String
    let position: String
    let lastname: String
    let role: String
    let firstname: String
    let email: String
    let token: String
    let permissions: String
    
    struct Login: Codable {
        let email: String
        let password: String
    }
}
