//
//  ClientInformationsSection.swift
//  Gestion
//
//  Created by Kevin Bertrand on 08/09/2022.
//

import SwiftUI

struct ClientInformationsSection: View {
    @Binding var firstname: String
    @Binding var lastname: String
    @Binding var company: String
    @Binding var tva: String
    @Binding var siret: String
    @Binding var phone: String
    @Binding var email: String
    @Binding var gender: Gender
    @Binding var type: PersonType
    
    var body: some View {
        Section {
            TextFieldFormWithIcon(text: $firstname, icon: "person.fill", title: "Firstname")
            TextFieldFormWithIcon(text: $lastname, icon: "person.fill", title: "Lastname")
            TextFieldFormWithIcon(text: $company, icon: "building.2.fill", title: "Company")
            TextFieldFormWithIcon(text: $tva, icon: "eurosign", title: "TVA")
            TextFieldFormWithIcon(text: $siret, icon: "person.badge.shield.checkmark.fill", title: "SIRET")
            TextFieldFormWithIcon(text: $phone, icon: "phone.fill", title: "Phone", keyboardType: .phonePad)
            TextFieldFormWithIcon(text: $email, icon: "envelope.fill", title: "Email", keyboardType: .emailAddress)
            
            Picker("Gender", selection: $gender) {
                ForEach(Gender.allCases, id: \.self) { gender in
                    Text(gender.rawValue)
                }
            }
            
            Picker("Person type", selection: $type) {
                ForEach(PersonType.allCases, id: \.self) { type in
                    Text(type.rawValue)
                }
            }
        } header: {
            Text("Informations")
        }
    }
}

struct ClientInformationsSection_Previews: PreviewProvider {
    static var previews: some View {
        ClientInformationsSection(firstname: .constant(""), lastname: .constant(""), company: .constant(""), tva: .constant(""), siret: .constant(""), phone: .constant(""), email: .constant(""), gender: .constant(.notDetermined), type: .constant(.company))
    }
}
