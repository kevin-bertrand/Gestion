//
//  LoginView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 30/08/2022.
//

import LocalAuthentication
import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var userController: UserController
    
    @Binding var showLogin: Bool
    
    let laContext = LAContext()
    
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
                TextFieldCustom(text: $userController.loginEmailTextField, icon: "person.fill", placeholder: "jon@doe.com", keyboardType: .emailAddress)
                HStack {
                    Spacer()
                    Button {
                        userController.loginSaveEmail.toggle()
                    } label: {
                        Text("Save email? ")
                        Image(systemName: userController.loginSaveEmail ? "checkmark.square" : "square")
                    }
                }
                .padding(.top, -30)
                TextFieldCustom(text: $userController.loginPasswordTextField, icon: "lock.fill", placeholder: "123", isSecure: true)
            }
            .padding(.vertical)
            
            Spacer()
            
            HStack {
                ButtonCustom(isLoading: .constant(false), action: {
                    userController.checkSaveEmail()
                    userController.performLogin()
                }, icon: "rectangle.portrait.and.arrow.forward", title: "Log in")
                
                if userController.getBiometricStatus() {
                    Button {
                        userController.loginWithBiometrics()
                    } label: {
                        Image(systemName: (laContext.biometryType == .faceID) ? "faceid" : "touchid")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding()
        .onAppear {
            userController.loginEmailTextField = userController.savedEmail
            
            if userController.savedEmail.isNotEmpty {
                userController.loginSaveEmail = true
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(showLogin: .constant(true))
            .environmentObject(UserController(appController: AppController()))
    }
}
