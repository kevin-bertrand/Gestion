//
//  SignupSubview.swift
//  Gestion
//
//  Created by Kevin Bertrand on 30/08/2022.
//

import SwiftUI

struct SignupSubview: View {
    @Binding var showSignup: Bool
    @State private var firstname: String = ""
    @State private var lastname: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordVerification: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button {
                    withAnimation {
                        showSignup = false
                    }
                } label: {
                    Image(systemName: "x.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
            }
            Spacer()
            
            Group {
                TextFieldCustom(text: $firstname, icon: "person.fill", placeholder: "Jon")
                TextFieldCustom(text: $lastname, icon: "person.fill", placeholder: "Doe")
                TextFieldCustom(text: $email, icon: "envelope.fill", placeholder: "jon.doe@email.com", keyboardType: .emailAddress)
                TextFieldCustom(text: $password, icon: "lock.fill", placeholder: "123", isSecure: true)
                TextFieldCustom(text: $passwordVerification, icon: "lock.fill", placeholder: "123", isSecure: true)
            }
            .padding(.vertical)
            
            Spacer()
            
            ButtonCustom(isLoading: .constant(false), action: {
                // TODO: Send signup email
            }, title: "Sign up")
            
        }.padding()
    }
}

struct SignupSubview_Previews: PreviewProvider {
    static var previews: some View {
        SignupSubview(showSignup: .constant(false))
    }
}
