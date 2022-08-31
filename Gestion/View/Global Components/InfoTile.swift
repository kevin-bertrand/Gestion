//
//  InfoTile.swift
//  Gestion
//
//  Created by Kevin Bertrand on 30/08/2022.
//

import SwiftUI

struct InfoTile: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.callout)
                .foregroundColor(.gray)
                .padding(.top)
            Text(value)
                .font(.title2)
                .foregroundColor(.accentColor)
                .padding()
        }
    }
}

struct InfoTile_Previews: PreviewProvider {
    static var previews: some View {
        InfoTile(title: "", value: "")
    }
}
