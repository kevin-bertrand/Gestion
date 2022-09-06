//
//  ClientTileView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 06/09/2022.
//

import SwiftUI

struct ClientTileView: View {
    let client: Client
    
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
        ClientTileView(client: Client(id: UUID(uuid: UUID_NULL), firstname: "Kevin", lastname: "Bertrand", company: "Desyntic", phone: "", email: "", personType: .company, gender: .man, address: Address.Id(id: ""), siret: "", tva: ""))
    }
}
