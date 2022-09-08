//
//  ClientListSelectingView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 06/09/2022.
//

import SwiftUI

struct ClientListSelectingView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var clientController: ClientController
    @EnvironmentObject var userController: UserController
    
    @Binding var client: Client.Informations
    
    var body: some View {
        List(clientController.clients, id: \.id) { clientInformations in
            ClientTileView(client: clientInformations)
                .onTapGesture {
                    self.client = clientInformations
                    dismiss()
                }
        }
        .onAppear {
            clientController.gettingList(for: userController.connectedUser)
        }
        .searchable(text: $clientController.searchingField)
    }
}

struct ClientListSelectingView_Previews: PreviewProvider {
    static var previews: some View {
        ClientListSelectingView(client: .constant(ClientController.emptyClientInfo))
    }
}
