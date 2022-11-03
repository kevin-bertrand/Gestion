//
//  EstimateDetailView.swift
//  Gestion-Mac
//
//  Created by Kevin Bertrand on 28/10/2022.
//

import SwiftUI

struct EstimateDetailView: View {
    let estimate: Estimate.Informations = .init(id: UUID(), reference: "1234", internalReference: "5678", object: "Test", totalServices: 10.0, totalMaterials: 123.5, totalDivers: 102.0, total: 235.0, status: .inCreation, limitValidityDate: Date(), sendingDate: Date(), isArchive: false, client: .init(id: UUID(), firstname: "Kevin", lastname: "Bertrand", company: "Desyntic", phone: "0123456789", email: "k.bertrand@desyntic.com", personType: .person, gender: .man, siret: "124", tva: "TVA123", address: .init(id: String(), roadName: "soik,", streetNumber: "1", complement: "boite 12345", zipCode: "75014", city: "Paris", country: "France", latitude: 12.01, longitude: 102.2, comment: "ok,")), products: [.init(id: UUID(), quantity: 2, reduction: 0.0, title: "p1", unity: "€/min", domain: .electricity, productCategory: .divers, price: 2.0)])
    
    let columns = [GridItem(.flexible(minimum: 750)), GridItem(.flexible(minimum: 750)), GridItem(.flexible(minimum: 750))]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(estimate.reference)
                .font(.largeTitle.bold())
                .padding()
            LazyVGrid(columns: columns, spacing: 25) {
                VStack(alignment: .leading) {
                    Text("Client informations")
                        .font(.title.bold())
                        .padding(.vertical)
                    
                    if let firstname = estimate.client.firstname,
                       let lastname = estimate.client.lastname {
                        Label("\(estimate.client.gender == .man ? "M " : ((estimate.client.gender == .woman) ? "Mme " : ""))\(firstname) \(lastname)", systemImage: "person.fill")
                    }
                    
                    if let company = estimate.client.company {
                        Label("\(company)", systemImage: "building.2.fill")
                    }
                    
                    Label("\(estimate.client.address.streetNumber) \(estimate.client.address.roadName)\n\(estimate.client.address.zipCode), \(estimate.client.address.city)\n\(estimate.client.address.country)", systemImage: "pin.fill")
                    Label("\((estimate.client.email))", systemImage: "envelope.fill")
                    Label("\(estimate.client.phone)", systemImage: "phone.fill")
                    
                    if let tva = estimate.client.tva {
                        Label("TVA: \(tva)", systemImage: "eurosign")
                    }
                    
                    if let siret = estimate.client.siret {
                        Label("SIRET: \(siret)", systemImage: "person.badge.shield.checkmark.fill")
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(25)
            }
            .padding()
            Spacer()
        }
    }
}

struct EstimateDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EstimateDetailView()
    }
}
