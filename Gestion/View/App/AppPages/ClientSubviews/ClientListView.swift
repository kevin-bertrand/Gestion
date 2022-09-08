//
//  ClientListView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 06/09/2022.
//

import SwiftUI

struct ClientListView: View {
    @EnvironmentObject var clientController: ClientController
    @EnvironmentObject var userController: UserController
    
    var body: some View {
        List {
            ForEach(clientController.clients, id: \.email) { client in
                ClientTileView(client: client)
            }
        }
        .searchable(text: $clientController.searchingField)
        .onAppear {
            clientController.gettingList(for: userController.connectedUser)
        }
        .navigationTitle("Client list")
        .toolbar {
            NavigationLink {
                CreateClient()
            } label: {
                Image(systemName: "plus.circle")
            }

        }
    }
}

struct ClientListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ClientListView()
                .environmentObject(ClientController(appController: AppController()))
                .environmentObject(UserController(appController: AppController()))
        }
    }
}
