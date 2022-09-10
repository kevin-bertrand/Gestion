//
//  CreateClient.swift
//  Gestion
//
//  Created by Kevin Bertrand on 06/09/2022.
//

import SwiftUI

struct CreateClient: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var userController: UserController
    @EnvironmentObject var clientController: ClientController
    
    @State private var client: Client.Create = ClientController.emptyClientCreation
    
    var body: some View {
        Form {
            ClientInformationsSection(firstname: $client.firstname, lastname: $client.lastname, company: $client.company, tva: $client.tva, siret: $client.siret, phone: $client.phone, email: $client.email, gender: $client.gender, type: $client.personType)
            
            AddressModificationSection(address: $client.address)
        }
        .navigationTitle("Update client")
        .toolbar {
            Button {
                clientController.create(client: client,
                                        for: userController.connectedUser)
            } label: {
                Image(systemName: "v.circle")
            }
        }
        .onChange(of: clientController.createSuccess) { newValue in
            if newValue {
                clientController.createSuccess = false
                dismiss()
            }
        }
    }
}

struct CreateClient_Previews: PreviewProvider {
    static var previews: some View {
        CreateClient()
    }
}
