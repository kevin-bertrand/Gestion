//
//  UserUpdateView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 10/09/2022.
//

import SwiftUI

struct UserUpdateView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var userController: UserController
    @State private var user: User.Update = UserManager.userUpdate
    
    var body: some View {
        Form {
            Section("Personal Informations") {
                Picker("Gender", selection: $user.gender) {
                    ForEach(Gender.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                TextFieldFormWithIcon(text: $user.firstname, icon: "person.fill", title: "Firstname")
                TextFieldFormWithIcon(text: $user.lastname, icon: "person.fill", title: "Lastname")
                TextFieldFormWithIcon(text: $user.email, icon: "envelope.fill", title: "Email", keyboardType: .emailAddress)
                TextFieldFormWithIcon(text: $user.phone, icon: "phone.fill", title: "Phone", keyboardType: .phonePad)
            }
            
            Section("Company") {
                TextField("Role", text: $user.role)
                Picker("Position", selection: $user.position) {
                    ForEach(Position.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
            }
            
            AddressModificationSection(address: $user.address)
        }
        .navigationTitle("Update informations")
        .toolbar {
            Button {
                userController.updateUser(user)
            } label: {
                Image(systemName: "v.circle")
            }
        }
        .onAppear {
            if let user = userController.connectedUser {
                self.user = user.toUpdate()
            } else {
                dismiss()
            }
        }
        .onChange(of: userController.userIsUpdated) { newValue in
            if newValue {
                self.userController.userIsUpdated = false
                dismiss()
            }
        }
    }
}

struct UserUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserUpdateView()
                .environmentObject(UserController(appController: AppController()))
        }
    }
}
