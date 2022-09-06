//
//  AddInvoiceView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 31/08/2022.
//

import SwiftUI

struct AddInvoiceView: View {
    @EnvironmentObject var invoiceController: InvoicesController
    @EnvironmentObject var userController: UserController
        
    @State private var services: [String] = []
    @State private var materials: [String] = []
    @State private var divers: [String] = []
    
    @State private var client: Client.Informations = ClientController.emptyClientInfo
    
    var body: some View {
        Form {
            ClientDetailsView(selectedClient: $client, canSelectUser: true)
            
            Section {
                TextField("Référence interne", text: $invoiceController.newInvoice.internalReference)
                DatePicker(selection: $invoiceController.newInvoice.limitPayementDate, displayedComponents: .date) {
                    Text("Date de validité")
                }
                Picker("Statut", selection: $invoiceController.newInvoice.status) {
                    ForEach(InvoiceStatus.allCases, id: \.self) { status in
                        Text(status.rawValue)
                    }
                }
            } header: {
                Text("Informations")
            }
            
            ProductListUpdateView(sectionTitle: "Services", products: $services)
            ProductListUpdateView(sectionTitle: "Materials", products: $materials)
            ProductListUpdateView(sectionTitle: "Divers", products: $divers)
            
            Section {
                
            } header: {
                Text("Total")
            }
        }
        .navigationTitle(invoiceController.newInvoice.reference)
        .onAppear {
            invoiceController.gettingNewReference(for: userController.connectedUser)
        }
    }
}

struct AddInvoiceView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddInvoiceView()
                .environmentObject(InvoicesController(appController: AppController()))
                .environmentObject(UserController(appController: AppController()))
        }
    }
}
