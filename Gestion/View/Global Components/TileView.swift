//
//  TileView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 30/08/2022.
//

import SwiftUI

struct TileView: View {
    var icon: String
    var title: String
    var value: String
    var limit: String
    
    var body: some View {
        RoundedRectangleCustom {
            AnyView(HStack(spacing: 20) {
                Image(systemName: icon)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.red)
                VStack(spacing: 10) {
                    Text(title)
                    Text(value)
                        .foregroundColor(.gray)
                        .font(.callout)
                    Text(limit)
                        .foregroundColor(.gray)
                        .font(.callout)
                }
            }.padding())
        }.frame(width: 250, height: 150)
    }
}

struct TileView_Previews: PreviewProvider {
    static var previews: some View {
        TileView(icon: "", title: "", value: "", limit: "")
    }
}
