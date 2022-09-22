//
//  ClientTile.swift
//  Gestion
//
//  Created by Kevin Bertrand on 31/08/2022.
//

//import SwiftUI
//
//struct ClientTile: View {
//    let client: Client.Informations
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            if let company = client.company {
//                Text("\(company)")
//                    .bold()
//            }
//            if let firstname = client.firstname, let lastname = client.lastname {
//                Text("\(client.gender == .man ? "M." : client.gender == .woman ? "Mme." : "") \(lastname) \(firstname)")
//            }
//            
//            Text("\(client.address.streetNumber) \(client.address.roadName)")
//            Text("\(client.address.zipCode) \(client.address.city) – \(client.address.country)")
//            if let siret = client.siret {
//                Text("Siret : \(siret)")
//            }
//            if let tva = client.tva {
//                Text("\(tva)")
//            }
//        }
//        .padding()
//        .border(.black)
//    }
//}
//
//struct ClientTile_Previews: PreviewProvider {
//    static var previews: some View {
//        ClientTile(client: ClientController.emptyClientInfo)
//    }
//}
