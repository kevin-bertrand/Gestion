//
//  UserUpdatePasswordView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 10/09/2022.
//

import SwiftUI

struct UserUpdatePasswordView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject private var userController: UserController
    
    @State private var updatePasswod: User.UpdatePassword = .init(id: UUID(uuid: UUID_NULL), oldPassword: "", newPassword: "", newPasswordVerification: "")
        
    var body: some View {
        VStack {
            Spacer()
            
            Group {
                TextFieldCustom(text: $updatePasswod.oldPassword, icon: "lock.fill", placeholder: "Old password", isSecure: true)
                
                TextFieldCustom(text: $updatePasswod.newPassword, icon: "lock.fill", placeholder: "New password", isSecure: true)
                
                TextFieldCustom(text: $updatePasswod.newPasswordVerification, icon: "lock.fill", placeholder: "New password verification", isSecure: true)
                
                Text(userController.updateErrorMessage)
                    .foregroundColor(.red)
                    .bold()
            }.padding(.vertical)
            
            Spacer()
            
            ButtonCustom(isLoading: .constant(false), action: {
                userController.updatePassword(updatePasswod)
            }, title: "Update")
            .disabled((updatePasswod.oldPassword == "" || updatePasswod.newPassword == "" || updatePasswod.newPasswordVerification == "") ? true : false)
        }
        .padding()
        .navigationTitle("Update password")
        .onAppear {
            if let userId = userController.connectedUser?.id {
                self.updatePasswod = .init(id: userId, oldPassword: "", newPassword: "", newPasswordVerification: "")
            } else {
                dismiss()
            }
        }
        .onChange(of: userController.updatePasswordSucces) { newValue in
            if newValue {
                userController.updatePasswordSucces = false
                dismiss()
            }
        }
    }
}

struct UserUpdatePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserUpdatePasswordView()
                .environmentObject(UserController(appController: AppController()))
        }
    }
}
