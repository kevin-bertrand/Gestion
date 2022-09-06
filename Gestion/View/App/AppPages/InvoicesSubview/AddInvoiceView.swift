//
//  AddInvoiceView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 31/08/2022.
//

import SwiftUI

struct AddInvoiceView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var invoiceController: InvoicesController
    @EnvironmentObject var userController: UserController

    @State private var newInvoice: Invoice.Create = .init(reference: "",
                                                          internalReference: "",
                                                          object: "",
                                                          totalServices: 0,
                                                          totalMaterials: 0,
                                                          totalDivers: 0,
                                                          total: 0,
                                                          reduction: 0,
                                                          grandTotal: 0,
                                                          status: .inCreation,
                                                          limitPayementDate: "",
                                                          clientID: UUID(uuid: UUID_NULL),
                                                          products: [])
    @State private var limitDate: Date = Date()
    @State private var products: [Product.Informations] = []
    @State private var client: Client.Informations = ClientController.emptyClientInfo
    
    var body: some View {
        Form {
            ClientDetailsView(selectedClient: $client, canSelectUser: true)
            
            Section {
                TextField("Référence interne", text: $newInvoice.internalReference)
                TextField("Object", text: $newInvoice.object)
                DatePicker(selection: $limitDate, displayedComponents: .date) {
                    Text("Date de validité")
                }
                Picker("Statut", selection: $newInvoice.status) {
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
                Text("Total services: \(newInvoice.totalServices.twoDigitPrecision) €")
                Text("Total material: \(newInvoice.totalMaterials.twoDigitPrecision) €")
                Text("Total Divers: \(newInvoice.totalDivers.twoDigitPrecision) €")
                Text("Grand total: \(newInvoice.grandTotal.twoDigitPrecision) €")
                    .font(.title2.bold())
            } header: {
                Text("Total")
            }
        }
        .onChange(of: products, perform: { newValue in
            newInvoice.totalDivers = calculateTotal(for: .divers)
            newInvoice.totalServices = calculateTotal(for: .service)
            newInvoice.totalMaterials = calculateTotal(for: .material)
            newInvoice.total = calculateTotal(for: nil)
            newInvoice.grandTotal = newInvoice.total
            
            newInvoice.products = products.map({
                .init(productID: $0.id, quantity: $0.quantity)
            })
        })
        .onChange(of: invoiceController.newInvoiceReference, perform: { newValue in
            newInvoice.reference = newValue
        })
        .onChange(of: limitDate, perform: { newValue in
            newInvoice.limitPayementDate = newValue.ISO8601Format()
        })
        .onChange(of: client, perform: { newValue in
            newInvoice.clientID = newValue.id ?? UUID(uuid: UUID_NULL)
        })
        .onChange(of: invoiceController.successCreatingNewInvoice, perform: { newValue in
            if newValue {
                self.presentationMode.wrappedValue.dismiss()
            }
        })
        .navigationTitle(newInvoice.reference)
        .onAppear {
            invoiceController.gettingNewReference(for: userController.connectedUser)
        }
        .toolbar {
            Button {
                invoiceController.create(invoice: newInvoice, by: userController.connectedUser)
            } label: {
                Image(systemName: "v.circle")
            }
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
