//
//  AddInvoiceView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 31/08/2022.
//

import SwiftUI

struct AddInvoiceView: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var invoiceController: InvoicesController
    @EnvironmentObject var userController: UserController

    @State private var newInvoice: Invoice.Create = InvoicesController.emptyCreateInvoice
    @State private var limitDate: Date = Date()
    @State private var products: [Product.Informations] = []
    @State private var client: Client.Informations = ClientController.emptyClientInfo
    @State private var comment: String = ""
    @State private var domain: Domain = .electricity
    
    var body: some View {
        Form {
            ClientDetailsView(selectedClient: $client, canSelectUser: true)
            
            Section {
                Picker("Domain", selection: $domain) {
                    ForEach(Domain.allCases, id: \.self) { domain in
                        Text(domain.rawValue)
                    }
                }
                HStack {
                    Text("Internal ref")
                    Spacer()
                    Text(invoiceController.newInternalReference)
                        .foregroundColor(.gray)
                }
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
                TextEditor(text: $comment)
            } header: {
                Text("Comments")
            }
            
            Section {
                NavigationLink {
                    SelectProductView(selectedProducts: $products)
                } label: {
                    Text("Select new product")
                        .foregroundColor(.accentColor)
                }
            }
            
            ProductListUpdateView(products: $products,
                                  total: $newInvoice.totalServices,
                                  sectionTitle: "Services",
                                  category: .service)
            ProductListUpdateView(products: $products,
                                  total: $newInvoice.totalMaterials,
                                  sectionTitle: "Materials",
                                  category: .material)
            ProductListUpdateView(products: $products,
                                  total: $newInvoice.totalDivers,
                                  sectionTitle: "Divers",
                                  category: .divers)

            TotalSectionView(totalService: newInvoice.totalServices,
                             totalMaterials: newInvoice.totalMaterials,
                             totalDivers: newInvoice.totalDivers,
                             total: newInvoice.total)
            
        }
        .onChange(of: products, perform: { newValue in
            newInvoice.total = 0
            newValue.forEach({ newInvoice.total += ($0.quantity * $0.price) })
            newInvoice.grandTotal = newInvoice.total
            
            newInvoice.products = products.map({
                .init(productID: $0.id, quantity: $0.quantity, reduction: $0.reduction)
            })
        })
        .onChange(of: invoiceController.newInvoiceReference, perform: { newValue in
            newInvoice.reference = newValue
        })
        .onChange(of: limitDate, perform: { newValue in
            newInvoice.limitPayementDate = ISO8601DateFormatter().string(from: newValue)
        })
        .onChange(of: client, perform: { newValue in
            newInvoice.clientID = newValue.id ?? UUID(uuid: UUID_NULL)
        })
        .onChange(of: invoiceController.successCreatingNewInvoice, perform: { newValue in
            if newValue {
                invoiceController.successCreatingNewInvoice = false
                dismiss()
            }
        })
        .onChange(of: comment, perform: { newValue in
            if comment.isEmpty {
                newInvoice.comment = nil
            } else {
                newInvoice.comment = newValue
            }
        })
        .onChange(of: domain, perform: { newValue in
            invoiceController.gettingNewInternalReference(by: userController.connectedUser, for: newValue)
        })
        .onChange(of: invoiceController.newInternalReference, perform: { newValue in
            newInvoice.internalReference = newValue
        })
        .navigationTitle(newInvoice.reference)
        .onAppear {
            invoiceController.gettingNewReference(for: userController.connectedUser)
            invoiceController.gettingNewInternalReference(by: userController.connectedUser, for: domain)
        }
        .onDisappear {
            invoiceController.newInvoiceReference = ""
        }
        .toolbar {
            Button {
                invoiceController.create(invoice: newInvoice, by: userController.connectedUser)
            } label: {
                Image(systemName: "v.circle")
            }
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
