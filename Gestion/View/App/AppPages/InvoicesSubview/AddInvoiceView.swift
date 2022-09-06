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

    @State private var products: [Product.CreateDocument] = []
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
            
            Section {
                NavigationLink {
                    SelectProductView(selectedProducts: $products)
                } label: {
                    Text("Select new product")
                        .foregroundColor(.accentColor)
                }
            }
            
            ProductListUpdateView(sectionTitle: "Services",
                                  products: $products,
                                  category: .service)
            ProductListUpdateView(sectionTitle: "Materials",
                                  products: $products,
                                  category: .material)
            ProductListUpdateView(sectionTitle: "Divers",
                                  products: $products,
                                  category: .divers)
            
            Section {
                Text("Total services: \(calculateTotal(for: .service).twoDigitPrecision) €")
                Text("Total material: \(calculateTotal(for: .material).twoDigitPrecision) €")
                Text("Total Divers: \(calculateTotal(for: .divers).twoDigitPrecision) €")
                Text("Grand total: \(calculateTotal(for: nil).twoDigitPrecision) €")
                    .font(.title2.bold())
            } header: {
                Text("Total")
            }
        }
        .navigationTitle(invoiceController.newInvoice.reference)
        .onAppear {
            invoiceController.gettingNewReference(for: userController.connectedUser)
        }
    }
    
    private func calculateTotal(for category: ProductCategory?) -> Double {
        var total = 0.0
        for product in products {
            if let category = category {
                if product.productCategory == category {
                    total += (product.price * product.quantity)
                }
            } else {
                total += (product.price * product.quantity)
            }
        }
        
        return total
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
