//
//  UpdateClientView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 06/09/2022.
//

import SwiftUI

struct UpdateClientView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var userController: UserController
    @EnvironmentObject var clientController: ClientController
    
    @Binding var selectedClient: Client.Informations
    @State private var client: Client.Update = ClientController.emptyClientUpdate
    
    var body: some View {
        Form {
            ClientInformationsSection(firstname: $client.firstname, lastname: $client.lastname, company: $client.company, tva: $client.tva, siret: $client.siret, phone: $client.phone, email: $client.email, gender: $client.gender, type: $client.personType)
            
            ClientAddressModificationSection(address: .init(get: {
                client.address.toCreate()
            }, set: {
                client.address.roadName = $0.roadName
                client.address.streetNumber = $0.streetNumber
                client.address.complement = $0.complement
                client.address.zipCode = $0.zipCode
                client.address.city = $0.city
                client.address.country = $0.country
                client.address.latitude = $0.latitude
                client.address.longitude = $0.longitude
                client.address.comment = $0.comment
            }))
        }
        .navigationTitle("Update client")
        .toolbar {
            Button {
                clientController.update(client: client.toInformation(), for: userController.connectedUser)
            } label: {
                Image(systemName: "v.circle")
            }
        }
        .onAppear {
            client = selectedClient.toUpdate()
        }
        .onChange(of: clientController.updateSuccess) { newValue in
            if newValue {
                selectedClient = client.toInformation()
                clientController.updateSuccess = false
                dismiss()
            }
        }
    }
}

struct UpdateClientView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UpdateClientView(selectedClient: .constant(ClientController.emptyClientInfo))
                .environmentObject(UserController(appController: AppController()))
                .environmentObject(ClientController(appController: AppController()))
        }
    }
}
