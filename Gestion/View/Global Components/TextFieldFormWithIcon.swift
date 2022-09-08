//
//  TextFieldFormWithIcon.swift
//  Gestion
//
//  Created by Kevin Bertrand on 08/09/2022.
//

import SwiftUI

struct TextFieldFormWithIcon: View {
    @Binding var text: String
    
    let icon: String?
    let title: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        HStack {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(.accentColor)
            }
            TextField(title, text: $text)
                .keyboardType(keyboardType)
        }
    }
}

struct TextFieldFormWithIcon_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldFormWithIcon(text: .constant(""), icon: "", title: "")
    }
}
