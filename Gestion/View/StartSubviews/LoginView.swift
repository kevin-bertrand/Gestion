//
//  LoginView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 30/08/2022.
//

import SwiftUI

struct LoginView: View {
    @Binding var showLogin: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button {
                    withAnimation {
                        showLogin = false
                    }
                } label: {
                    Image(systemName: "x.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
            }
            
            Spacer()
            
            Group {
                TextFieldCustom(text: $email, icon: "person.fill", placeholder: "jon@doe.com", keyboardType: .emailAddress)
                TextFieldCustom(text: $password, icon: "lock.fill", placeholder: "123", isSecure: true)
            }
            .padding(.vertical)
            
            Spacer()
            
            ButtonCustom(isLoading: .constant(false), action: {
                // TODO: Perform login
            }, icon: "rectangle.portrait.and.arrow.forward", title: "Log in")
        }.padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(showLogin: .constant(true))
    }
}
