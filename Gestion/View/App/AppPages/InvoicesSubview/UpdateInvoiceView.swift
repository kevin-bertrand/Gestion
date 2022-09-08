//
//  UpdateInvoiceView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 31/08/2022.
//

import SwiftUI

struct UpdateInvoiceView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var invoiceController: InvoicesController
    @EnvironmentObject var userController: UserController
    
    @State var invoice: Invoice.Update
    @State var client: Client.Informations
    @State private var limitDate: Date = Date()
    @State var products: [Product.Informations] = []
    @State private var payment: Payment = PaymentController.emptyPayment
    
    var body: some View {
        Form {
            ClientDetailsView(selectedClient: $client)
            
            Section {
                TextField("Référence interne", text: $invoice.internalReference)
                TextField("Object", text: $invoice.object)
                DatePicker(selection: $limitDate, displayedComponents: .date) {
                    Text("Date de validité")
                }
                Picker("Statut", selection: $invoice.status) {
                    ForEach(InvoiceStatus.allCases, id: \.self) { status in
                        Text(status.rawValue)
                    }
                }
            } header: {
                Text("Informations")
            }
            
            Section("Payment information") {
                NavigationLink {
                    SelectPaymentListView(selectedPayment: $payment)
                } label: {
                    Text("Select payment method")
                        .foregroundColor(.accentColor)
                }
                
                Text("Title: \(payment.title)")
                Text("BIC: \(payment.bic)")
                Text("IBAN: \(payment.iban)")
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
                                  total: $invoice.totalServices,
                                  sectionTitle: "Services",
                                  category: .service)
            ProductListUpdateView(products: $products,
                                  total: $invoice.totalMaterials,
                                  sectionTitle: "Materials",
                                  category: .material)
            ProductListUpdateView(products: $products,
                                  total: $invoice.totalDivers,
                                  sectionTitle: "Divers",
                                  category: .divers)
            
            TotalSectionView(totalService: invoice.totalServices, totalMaterials: invoice.totalMaterials, totalDivers: invoice.totalDivers, grandTotal: invoice.grandTotal)            
        }
        .onChange(of: products, perform: { newValue in
            invoice.total = 0
            newValue.forEach({ invoice.total += ($0.quantity * $0.price) })
            invoice.grandTotal = invoice.total
            
            invoice.products = products.map({
                .init(productID: $0.id, quantity: $0.quantity)
            })
        })
        .onChange(of: limitDate, perform: { newValue in
            invoice.limitPayementDate = newValue.ISO8601Format()
        })
        .onChange(of: invoiceController.successUpdateInvoice, perform: { newValue in
            if newValue {
                invoiceController.successUpdateInvoice = false
                dismiss()
            }
        })
        .navigationTitle(invoice.reference)
        .toolbar {
            Button {
                if payment.id != UUID(uuid: UUID_NULL) {
                    invoice.paymentID = payment.id
                }
                
                invoiceController.update(invoice: invoice, by: userController.connectedUser)
            } label: {
                Image(systemName: "v.circle")
            }
        }
        .onAppear {
            if let oldPayment = invoiceController.selectedInvoice.payment {
                payment = oldPayment
            }
        }
    }
}

struct UpdateInvoiceView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UpdateInvoiceView(invoice: InvoicesController.emptyUpdateInvoice,
                              client: ClientController.emptyClientInfo)
        }
    }
}
