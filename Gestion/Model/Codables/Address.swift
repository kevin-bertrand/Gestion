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
    let comment: String?
    
    func toNew() -> Address.New {
        return .init(id: self.id, roadName: self.roadName, streetNumber: self.streetNumber, complement: self.complement ?? "", zipCode: self.zipCode, city: self.city, country: self.country, latitude: self.latitude, longitude: self.longitude, comment: self.comment ?? "")
    }
    
    struct Id: Codable {
        let id: String
    }
    
    struct New: Codable {
        let id: String
        var roadName: String
        var streetNumber: String
        var complement: String
        var zipCode: String
        var city: String
        var country: String
        var latitude: Double
        var longitude: Double
        var comment: String
        
        func toAddress() -> Address {
            return .init(id: self.id, roadName: self.roadName, streetNumber: self.streetNumber, complement: self.complement, zipCode: self.zipCode, city: self.city, country: self.country, latitude: self.latitude, longitude: self.longitude, comment: self.comment)
        }
        
        func toCreate() -> Address.Create {
            return .init(roadName: self.roadName, streetNumber: self.streetNumber, complement: self.complement, zipCode: self.zipCode, city: self.city, country: self.country, latitude: self.latitude, longitude: self.longitude, comment: self.comment)
        }
    }
    
    struct Create: Codable {
        var roadName: String
        var streetNumber: String
        var complement: String
        var zipCode: String
        var city: String
        var country: String
        var latitude: Double
        var longitude: Double
        var comment: String
    }
}
