//
//  ClientTileView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 06/09/2022.
//

import SwiftUI

struct ClientTileView: View {
    let client: Client.Informations
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Company:")
                    .bold()
                Text(client.company ?? "---")
            }.font(.title2)
            
            if let firstname = client.firstname, let lastname = client.lastname {
                Text("\(firstname) \(lastname)")
            } else {
                Text("---")
            }
        }
    }
}

struct ClientTileView_Previews: PreviewProvider {
    static var previews: some View {
        ClientTileView(client: Client.Informations(id: nil, firstname: nil, lastname: nil, company: nil, phone: "", email: "", personType: .company, gender: nil, siret: nil, tva: nil, address: Address(id: "", roadName: "", streetNumber: "", complement: nil, zipCode: "", city: "", country: "", latitude: 0, longitude: 0, comment: nil)))
    }
}
