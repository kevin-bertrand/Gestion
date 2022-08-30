//
//  TextFieldCustom.swift
//  Gestion
//
//  Created by Kevin Bertrand on 30/08/2022.
//

import SwiftUI

struct TextFieldCustom: View {
    // MARK: State properties
    @State private var showPassword = false
    
    // MARK: Bingin properties
    @Binding var text: String
    
    // MARK: Local properties
    let icon: String?
    let placeholder: String
    
    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool = false
    
    var body: some View {
        HStack(spacing: 0) {
            if let icon = icon,
               let image = Image(systemName: icon) {
                image
                    .padding()
                    .foregroundColor(.accentColor)
            }
            
            Group {
                Group {
                    if isSecure && !showPassword {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                            .autocorrectionDisabled(keyboardType == .default ? false : true)
                            .autocapitalization(keyboardType == .default ? .sentences : .none)
                    }
                }
                .padding()
                .keyboardType(keyboardType)
                .frame(height: 50)
                
                if isSecure {
                    Button {
                        showPassword.toggle()
                    } label: {
                        if showPassword {
                            Image(systemName: "eye.slash")
                        } else {
                            Image(systemName: "eye")
                        }
                    }
                    .padding()
                    .frame(height: 50)
                }
                
            }
            .background(Color("TextFieldBackground"))
        }
        .background(Color("ButtonIconBackground"))
        .cornerRadius(25)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .strokeBorder(Color("ButtonIconBackground"), style: .init(lineWidth: 1))
            , alignment: .center)
        .frame(height: 50)
    }
}

struct TextFieldCustom_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldCustom(text: .constant(""), icon: "", placeholder: "")
    }
}
