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
    @State private var profileUrl: URL?
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack {
                AsyncImage(url: profileUrl) { image in
                    image
                        .resizable()
                        .clipShape(Circle())
                        .scaledToFit()
                        .overlay(Circle().stroke(style: .init(lineWidth: 1)))
                } placeholder: {
                    Image(systemName: "person.circle").resizable()
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
            
            if let urlString = userController.connectedUser?.profilePicture,
               let url = URL(string: urlString) {
                profileUrl = url
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
