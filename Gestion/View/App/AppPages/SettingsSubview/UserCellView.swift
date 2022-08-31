//
//  UserCellView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 30/08/2022.
//

import SwiftUI

struct UserCellView: View {
    var body: some View {
        HStack {
            Spacer()
            
            VStack {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .padding(5)
                
                Group {
                    Text("Unknown user")
                        .bold()
                        .font(.title)
                }
            }
            Spacer()
        }
    }
}

struct UserCellView_Previews: PreviewProvider {
    static var previews: some View {
        UserCellView()
    }
}
