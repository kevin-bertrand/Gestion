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
    @State private var facturationDate: Date = Date()
    @State var products: [Product.Informations] = []
    @State private var payment: Payment = PaymentController.emptyPayment
    @State private var comment: String = ""
    @State private var hasAnInterestsCeiling: Bool = false
    @State private var maxInterests: String = ""
    @State private var maxLimitInterets: Date = Date()
    
    var body: some View {
        Form {
            ClientDetailsView(selectedClient: $client, canSelectUser: true)
            
            Section {
                TextField("Référence interne", text: $invoice.internalReference)
                TextField("Object", text: $invoice.object)
                DatePicker(selection: $facturationDate, displayedComponents: .date) {
                    Text("Date de facturation")
                }
                DatePicker(selection: $limitDate, displayedComponents: .date) {
                    Text("Date de validité")
                }
                Picker("Statut", selection: $invoice.status) {
                    ForEach(InvoiceStatus.allCases, id: \.self) { status in
                        if status != .payed {
                            Text(status.rawValue)
                        }
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
                if hasAnInterestsCeiling {
                    Button {
                        hasAnInterestsCeiling = false
                        invoice.maxInterests = nil
                        invoice.limitMaximumInterests = nil
                    } label: {
                        Text("Remove interest limit")
                    }
                    TextField("Maximum interests", text: $maxInterests)
                        .keyboardType(.decimalPad)
                    DatePicker("Limit maximum", selection: $maxLimitInterets,displayedComponents: .date)
                } else {
                    Button {
                        hasAnInterestsCeiling = true
                        invoice.maxInterests = 0
                        invoice.limitMaximumInterests = ISO8601DateFormatter().string(from: Date())
                    } label: {
                        Text("Add interest limit")
                    }
                }
            } header: {
                Text("Interests")
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
            
            TotalSectionView(totalService: invoice.totalServices,
                             totalMaterials: invoice.totalMaterials,
                             totalDivers: invoice.totalDivers,
                             total: invoice.total)            
        }
        .onChange(of: products, perform: { newValue in
            invoice.total = 0
            newValue.forEach({ invoice.total += ($0.quantity * $0.price) })
            
            invoice.products = products.map({
                .init(productID: $0.id, quantity: $0.quantity, reduction: $0.reduction)
            })
        })
        .onChange(of: limitDate, perform: { newValue in
            invoice.limitPayementDate = newValue.ISO8601Format()
        })
        .onChange(of: facturationDate, perform: { newValue in
            invoice.facturationDate = newValue.ISO8601Format()
        })
        .onChange(of: invoiceController.successUpdateInvoice, perform: { newValue in
            if newValue {
                invoiceController.successUpdateInvoice = false
                dismiss()
            }
        })
        .onChange(of: comment, perform: { newValue in
            if newValue.isEmpty {
                invoice.comment = nil
            } else {
                invoice.comment = newValue
            }
        })
        .onChange(of: maxInterests, perform: { newValue in
            if let maxDouble = Double(maxInterests) {
                invoice.maxInterests = maxDouble
            }
        })
        .onChange(of: maxLimitInterets, perform: { newValue in
            invoice.limitMaximumInterests = ISO8601DateFormatter().string(from: newValue)
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
            
            if let limitPaymentDate = invoice.limitPayementDate,
               let date = limitPaymentDate.toDate{
                limitDate = date
            }
            
            if let date = invoice.facturationDate.toDate {
                facturationDate = date
            }
            
            if let comments = invoice.comment {
                comment = comments
            }
            
            if let interestsCeilingDate = invoiceController.selectedInvoice.limitMaximumInterests,
               let maxInterests = invoiceController.selectedInvoice.maxInterests {
                hasAnInterestsCeiling = true
                invoice.maxInterests = maxInterests
                self.maxInterests = "\(maxInterests)"
                invoice.limitMaximumInterests = ISO8601DateFormatter().string(from: interestsCeilingDate)
                self.maxLimitInterets = interestsCeilingDate
            }
        }
    }
}

struct UpdateInvoiceView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UpdateInvoiceView(invoice: InvoicesController.emptyUpdateInvoice,
                              client: ClientController.emptyClientInfo)
            .environmentObject(InvoicesController(appController: AppController()))
            .environmentObject(UserController(appController: AppController()))
        }
    }
}
