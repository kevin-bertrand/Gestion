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
    @State private var payment: Payment = Payment(id: UUID(uuid: UUID_NULL), title: "", iban: "", bic: "")
    
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
                Text("Total services: \(invoice.totalServices.twoDigitPrecision) €")
                Text("Total material: \(invoice.totalMaterials.twoDigitPrecision) €")
                Text("Total Divers: \(invoice.totalDivers.twoDigitPrecision) €")
                Text("Grand total: \(invoice.grandTotal.twoDigitPrecision) €")
                    .font(.title2.bold())
            } header: {
                Text("Total")
            }
        }
        .onChange(of: products, perform: { newValue in
            invoice.totalDivers = calculateTotal(for: .divers)
            invoice.totalServices = calculateTotal(for: .service)
            invoice.totalMaterials = calculateTotal(for: .material)
            invoice.total = calculateTotal(for: nil)
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

struct UpdateInvoiceView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UpdateInvoiceView(invoice: Invoice.Update(id: UUID(uuid: UUID_NULL),
                                                      reference: "",
                                                      internalReference: "",
                                                      object: "",
                                                      totalServices: 0,
                                                      totalMaterials: 0,
                                                      totalDivers: 0,
                                                      total: 0,
                                                      reduction: 0,
                                                      grandTotal: 0,
                                                      status: .inCreation,
                                                      products: []),
                              client: Client.Informations(id: nil,
                                                          firstname: nil,
                                                          lastname: nil,
                                                          company: nil,
                                                          phone: "",
                                                          email: "",
                                                          personType: .company,
                                                          gender: nil,
                                                          siret: nil,
                                                          tva: nil,
                                                          address: Address(id: "",
                                                                           roadName: "",
                                                                           streetNumber: "",
                                                                           complement: nil,
                                                                           zipCode: "",
                                                                           city: "",
                                                                           country: "",
                                                                           latitude: 0,
                                                                           longitude: 0,
                                                                           comment: nil)))
        }
    }
}
