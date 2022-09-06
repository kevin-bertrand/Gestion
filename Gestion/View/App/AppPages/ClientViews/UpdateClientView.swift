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
    @State private var client = Client.Update(id: UUID(uuid: UUID_NULL),
                                              firstname: "",
                                              lastname: "",
                                              company: "",
                                              phone: "",
                                              email: "",
                                              personType: .company,
                                              gender: .man,
                                              siret: "",
                                              tva: "",
                                              address: Address.New(id: "",
                                                                   roadName: "",
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
                clientController.update(client: Client.Informations(id: client.id,
                                                                                     firstname: client.firstname,
                                                                                     lastname: client.lastname,
                                                                                     company: client.company,
                                                                                     phone: client.phone,
                                                                                     email: client.email,
                                                                                     personType: client.personType,
                                                                                     gender: client.gender,
                                                                                     siret: client.siret,
                                                                                     tva: client.tva,
                                                                                     address: Address(id: client.address.id,
                                                                                                      roadName: client.address.roadName,
                                                                                                      streetNumber: client.address.streetNumber,
                                                                                                      complement: client.address.complement,
                                                                                                      zipCode: client.address.zipCode,
                                                                                                      city: client.address.city,
                                                                                                      country: client.address.country,
                                                                                                      latitude: 0,
                                                                                                      longitude: 0,
                                                                                                      comment: client.address.comment)),
                                        for: userController.connectedUser)
            } label: {
                Image(systemName: "v.circle")
            }
        }
        .onAppear {
            client = Client.Update(id: selectedClient.id ?? UUID(uuid: UUID_NULL),
                                   firstname: selectedClient.firstname ?? "",
                                   lastname: selectedClient.lastname ?? "",
                                   company: selectedClient.company ?? "",
                                   phone: selectedClient.phone,
                                   email: selectedClient.email,
                                   personType: selectedClient.personType,
                                   gender: selectedClient.gender ?? .notDetermined,
                                   siret: selectedClient.siret ?? "",
                                   tva: selectedClient.tva ?? "",
                                   address: Address.New(id: selectedClient.address.id,
                                                        roadName: selectedClient.address.roadName,
                                                        streetNumber: selectedClient.address.streetNumber,
                                                        complement: selectedClient.address.complement ?? "",
                                                        zipCode: selectedClient.address.zipCode,
                                                        city: selectedClient.address.city,
                                                        country: selectedClient.address.country,
                                                        latitude: 0,
                                                        longitude: 0,
                                                        comment: selectedClient.address.comment ?? ""))
        }
        .onChange(of: clientController.updateSuccess) { newValue in
            if newValue {
                selectedClient = Client.Informations(id: client.id,
                                                     firstname: client.firstname,
                                                     lastname: client.lastname,
                                                     company: client.company,
                                                     phone: client.phone,
                                                     email: client.email,
                                                     personType: client.personType,
                                                     gender: client.gender,
                                                     siret: client.siret,
                                                     tva: client.tva,
                                                     address: Address(id: client.address.id,
                                                                      roadName: client.address.roadName,
                                                                      streetNumber: client.address.streetNumber,
                                                                      complement: client.address.complement,
                                                                      zipCode: client.address.zipCode,
                                                                      city: client.address.city,
                                                                      country: client.address.country,
                                                                      latitude: 0,
                                                                      longitude: 0,
                                                                      comment: client.address.comment))
                dismiss()
            }
        }
    }
}

struct UpdateClientView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UpdateClientView(selectedClient: .constant(.init(id: nil, firstname: nil, lastname: nil, company: nil, phone: "", email: "", personType: .company, gender: nil, siret: nil, tva: nil, address: Address(id: "", roadName: "", streetNumber: "", complement: nil, zipCode: "", city: "", country: "", latitude: 0, longitude: 0, comment: nil))))
                .environmentObject(UserController(appController: AppController()))
                .environmentObject(ClientController(appController: AppController()))
        }
    }
}
