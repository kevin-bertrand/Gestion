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
    
    var body: some View {
        HStack {
            Image("Logo")
                .frame(width: 150, height: 400)
            
            Spacer(minLength: 200)
            
            VStack {
                TextField("Username", text: $username)
                    .padding()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
