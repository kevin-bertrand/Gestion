//
//  ClientTile.swift
//  Gestion
//
//  Created by Kevin Bertrand on 31/08/2022.
//

import SwiftUI

struct ClientTile: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Client")
                .bold()
            Text("Siret : 89158565500014")
            Text("7 Place Fulgence Bienvenue")
            Text("77600 Bussy-saint-Georges – France")
            Text("FR12345678901")
        }
        .padding()
        .border(.black)
    }
}

struct ClientTile_Previews: PreviewProvider {
    static var previews: some View {
        ClientTile()
    }
}
