//
//  ClientDetailsView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 06/09/2022.
//

import SwiftUI

struct ClientDetailsView: View {
    @Binding var selectedClient: Client.Informations
    var canSelectUser: Bool = false
    
    var body: some View {
        Section {
            if canSelectUser {
                NavigationLink {
                    ClientListSelectingView(client: $selectedClient)
                } label: {
                    Text("Select client")
                        .bold()
                        .foregroundColor(.accentColor)
                }
            }
            
            if let firstname = selectedClient.firstname,
               let lastname = selectedClient.lastname {
                Label("\(selectedClient.gender == .man ? "M " : ((selectedClient.gender == .woman) ? "Mme " : ""))\(firstname) \(lastname)", systemImage: "person.fill")
            }

            if let company = selectedClient.company {
                Label("\(company)", systemImage: "building.2.fill")
            }
            
            Label("\(selectedClient.address.streetNumber) \(selectedClient.address.roadName)\n\(selectedClient.address.zipCode), \(selectedClient.address.city)\n\(selectedClient.address.country)", systemImage: "pin.fill")
            Label("\((selectedClient.email))", systemImage: "envelope.fill")
            Label("\(selectedClient.phone)", systemImage: "phone.fill")
            
            if let tva = selectedClient.tva {
                Label("TVA: \(tva)", systemImage: "eurosign")
            }
            
            if let siret = selectedClient.siret {
                Label("SIRET: \(siret)", systemImage: "person.badge.shield.checkmark.fill")
            }
        } header: {
            Text("Client informations")
        }
    }
}

struct ClientDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ClientDetailsView(selectedClient: .constant(ClientController.emptyClientInfo))
    }
}
