//
//  UserCellView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 30/08/2022.
//

import SwiftUI

struct UserCellView: View {
    @EnvironmentObject var userController: UserController
    
    @State private var userName: String = ""
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack {
                Group {
                    if let image = userController.userProfilePicture {
                        Image(uiImage: image)
                            .resizable()
                            .clipShape(Circle())
                            .scaledToFill()
                            .overlay(Circle().stroke(style: .init(lineWidth: 1)))
                    } else {
                        Image(systemName: "person.circle")
                            .resizable()
                    }
                }
                .frame(width: 150, height: 150)
                .padding(5)

                Group {
                    Text(userName)
                        .bold()
                        .font(.title)
                        .multilineTextAlignment(.center)
                }
            }
            
            Spacer()
        }
        .onAppear {
            if let firstname = userController.connectedUser?.firstname,
               let lastname = userController.connectedUser?.lastname {
                userName = "\(firstname) \(lastname)"
            } else {
                userName = "Unknown user"
            }            
        }
    }
}

struct UserCellView_Previews: PreviewProvider {
    static var previews: some View {
        UserCellView()
            .environmentObject(UserController(appController: AppController()))
    }
}
