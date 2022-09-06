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
    
    @State private var client = Client.Create(firstname: "",
                                              lastname: "",
                                              company: "",
                                              phone: "",
                                              email: "",
                                              personType: .company,
                                              gender: .man,
                                              siret: "",
                                              tva: "",
                                              address: Address.Create(roadName: "",
                                                                   streetNumber: "",
                                                                   complement: "",
                                                                   zipCode: "",
                                                                   city: "",
                                                                   country: "",
                                                                   latitude: 0,
                                                                   longitude: 0,
                                                                   comment: ""))
    
    var body: some View {
        Form {
            Section {
                ClientInformationTextField(icon: "person.fill", title: "Firstname", text: $client.firstname)
                ClientInformationTextField(icon: "person.fill", title: "Lastname", text: $client.lastname)
                ClientInformationTextField(icon: "building.2.fill", title: "Company", text: $client.company)
                ClientInformationTextField(icon: "eurosign", title: "TVA", text: $client.tva)
                ClientInformationTextField(icon: "person.badge.shield.checkmark.fill", title: "TVA", text: $client.siret)
                ClientInformationTextField(icon: "phone.fill", title: "Phone", text: $client.phone, keyboardType: .phonePad)
                ClientInformationTextField(icon: "envelope.fill", title: "Email", text: $client.email, keyboardType: .emailAddress)
                Picker("Gender", selection: $client.gender) {
                    ForEach(Gender.allCases, id: \.self) { gender in
                        Text(gender.rawValue)
                    }
                }
                Picker("Person type", selection: $client.personType) {
                    ForEach(PersonType.allCases, id: \.self) { type in
                        Text(type.rawValue)
                    }
                }
            } header: {
                Text("Informations")
            }
            
            Section {
                ClientInformationTextField(icon: nil, title: "Street number", text: $client.address.streetNumber)
                ClientInformationTextField(icon: nil, title: "Road name", text: $client.address.roadName)
                ClientInformationTextField(icon: nil, title: "Complement", text: $client.address.complement)
                ClientInformationTextField(icon: nil, title: "Zip Code", text: $client.address.zipCode)
                ClientInformationTextField(icon: nil, title: "City", text: $client.address.city)
                ClientInformationTextField(icon: nil, title: "Country", text: $client.address.country)
                ClientInformationTextField(icon: nil, title: "Comment", text: $client.address.comment)
            } header: {
                Text("Address")
            }
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
