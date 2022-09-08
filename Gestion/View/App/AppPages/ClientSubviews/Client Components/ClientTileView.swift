//
//  ClientTileView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 06/09/2022.
//

import SwiftUI

struct ClientTileView: View {
    let client: Client.Informations
    
    var body: some View {
        NavigationLink {
            List{
                ClientDetailsView(selectedClient: .constant(client))
            }
            .toolbar {
                NavigationLink {
                    UpdateClientView(selectedClient: .constant(client))
                } label: {
                    Image(systemName: "pencil.circle")
                }
            }
            .navigationTitle("Client informations")
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    Text("Company:")
                        .bold()
                    Text(client.company ?? "---")
                }.font(.title2)
                
                if let firstname = client.firstname, let lastname = client.lastname {
                    Text("\(firstname) \(lastname)")
                } else {
                    Text("---")
                }
            }
        }
    }
}

struct ClientTileView_Previews: PreviewProvider {
    static var previews: some View {
        ClientTileView(client: ClientController.emptyClientInfo)
    }
}
