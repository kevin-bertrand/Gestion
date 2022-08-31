//
//  RoundedRectangleCustom.swift
//  Gestion
//
//  Created by Kevin Bertrand on 30/08/2022.
//

import SwiftUI

struct RoundedRectangleCustom: View {
    var overlay: () -> AnyView
    
    var body: some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(Color("TileBackground"))
            .shadow(color: .gray, radius: 2, x: 0, y: 2)
            .padding(5)
            .overlay(content: overlay)
    }
}

struct RoundedRectangleCustom_Previews: PreviewProvider {
    static var previews: some View {
        RoundedRectangleCustom {
            AnyView(Text("OK"))
        }
    }
}
