//
//  LoginView.swift
//  Gestion-Mac
//
//  Created by Kevin Bertrand on 22/10/2022.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    
    @Binding var isConnected: Bool
    
    var body: some View {
        HStack {
            Group {
                Spacer()
                
                Image("Logo")
                    .resizable()
                    .frame(width: 300, height: 400)
                    .padding(50)
                
                Spacer()
            }
            
            VStack {
                Group {
                    CustomTextField(text: $username, icon: "person.fill", placeholder: "example@email.com")
                    
                    CustomTextField(text: $password, icon: "lock.fill", placeholder: "Password", isSecure: true)

                    CustomButton(isLoading: .constant(false), action: {
                        isConnected = true
                    }, icon: "rectangle.portrait.and.arrow.right", title: "LOGIN")
                }
                .padding()
                .frame(maxWidth: 500)
                
                
            }
            .padding()
            .background(Color.white)
            
            Spacer()
                .background(Color.white)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isConnected: .constant(false))
    }
}
