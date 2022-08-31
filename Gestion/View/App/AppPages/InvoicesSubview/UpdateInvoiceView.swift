//
//  UpdateInvoiceView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 31/08/2022.
//

import SwiftUI

struct UpdateInvoiceView: View {
    @State private var internalRef: String = ""
    @State private var validityDate: Date = Date()
    @State private var status: [String] = ["1", "2"]
    @State private var selectedStatus: String = "1"
    
    @State private var services: [String] = []
    @State private var materials: [String] = []
    @State private var divers: [String] = []
    
    var body: some View {
        Form {
            Section {
                Label("Name", systemImage: "person.fill")
                Label("Address", systemImage: "pin.fill")
                Label("Email", systemImage: "envelope.fill")
                Label("Phone", systemImage: "phone.fill")
                Label("TVA", systemImage: "eurosign")
                Label("SIRET", systemImage: "person.badge.shield.checkmark.fill")
            } header: {
                Text("Client")
            }

            
            
            Section {
                TextField("Référence interne", text: $internalRef)
                DatePicker(selection: $validityDate, displayedComponents: .date) {
                    Text("Date de validité")
                }
                Picker("Statut", selection: $selectedStatus) {
                    ForEach(status, id: \.self) { stat in
                        Text(stat)
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
        .navigationTitle("F-202208-001")
    }
}

struct UpdateInvoiceView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UpdateInvoiceView()
        }
    }
}
