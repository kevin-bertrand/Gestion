//
//  AddressModificationSection.swift
//  Gestion
//
//  Created by Kevin Bertrand on 08/09/2022.
//

import SwiftUI

struct AddressModificationSection: View {
    @Binding var address: Address.Create
    
    var body: some View {
        Section {
            TextField("Street number", text: $address.streetNumber)
            TextField("Road name", text: $address.roadName)
            TextField("Complement", text: $address.complement)
            TextField("Zip code", text: $address.zipCode)
            TextField("City", text: $address.city)
            TextField("Country", text: $address.country)
            TextField("Comment", text: $address.comment)
        } header: {
            Text("Address")
        }
    }
}

struct AddressModificationSection_Previews: PreviewProvider {
    static var previews: some View {
        AddressModificationSection(address: .constant(Address.Create(roadName: "", streetNumber: "", complement: "", zipCode: "", city: "", country: "", latitude: 0, longitude: 0, comment: "")))
    }
}
