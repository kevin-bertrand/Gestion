//
//  ProductInformationTextField.swift
//  Gestion
//
//  Created by Kevin Bertrand on 07/09/2022.
//

import SwiftUI

struct ProductInformationTextField: View {
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

struct ProductInformationTextField_Previews: PreviewProvider {
    static var previews: some View {
        ProductInformationTextField(icon: "", title: "", text: .constant(""))
    }
}
