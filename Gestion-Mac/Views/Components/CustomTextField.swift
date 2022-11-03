//
//  CustomTextField.swift
//  Gestion-Mac
//
//  Created by Kevin Bertrand on 26/10/2022.
//

import SwiftUI

struct CustomTextField: View {
    // MARK: State properties
    @State private var showPassword = false
    
    // MARK: Bingin properties
    @Binding var text: String
    
    // MARK: Local properties
    let icon: String?
    let placeholder: String
    
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
                    }
                }
                .textFieldStyle(.plain)
                .padding()
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
                    .buttonStyle(.plain)
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

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(text: .constant("Test"), icon: "gear", placeholder: "isTesting", isSecure: true)
    }
}
