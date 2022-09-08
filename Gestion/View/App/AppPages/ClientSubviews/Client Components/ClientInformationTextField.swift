//
//  ClientInformationTextField.swift
//  Gestion
//
//  Created by Kevin Bertrand on 06/09/2022.
//

import SwiftUI

struct ClientInformationTextField: View {
    let icon: String?
    let title: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        HStack {
            if let icon = icon {
                Image(systemName: icon)
            }
            TextField(title, text: $text)
                .keyboardType(keyboardType)
        }
    }
}

struct ClientInformationTextField_Previews: PreviewProvider {
    static var previews: some View {
        ClientInformationTextField(icon: "person.fill", title: "Test", text: .constant(""))
    }
}
