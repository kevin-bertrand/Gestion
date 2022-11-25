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
    
    @State private var client: Client.Informations
    @State private var products: [Product.Informations]
    
    private let id: UUID
    private let reference: String
    @State private var internalReference: String
    @State private var object: String
    @State private var limitDate: Date
    @State private var facturationDate: Date
    @State private var payment: Payment
    @State private var comment: String
    @State private var hasAnInterestsCeiling: Bool
    @State private var maxInterestsValue: String
    @State private var maxInterestsDate: Date
    @State private var status: InvoiceStatus
    @State private var totalServices: Double
    @State private var totalMaterials: Double
    @State private var totalDivers: Double
    @State private var grandTotal: Double
    @State private var total: Double
    
    init(invoice: Invoice.Informations) {
        _client = State(initialValue: invoice.client)
        _products = State(initialValue: invoice.products)
        
        id = invoice.id
        reference = invoice.reference
        _internalReference = State(initialValue: invoice.internalReference)
        _object = State(initialValue: invoice.object)
        _payment = State(initialValue: invoice.payment ?? PaymentController.emptyPayment)
        _limitDate = State(initialValue: invoice.limitPayementDate)
        _facturationDate = State(initialValue: invoice.facturationDate)
        _comment = State(initialValue: invoice.comment ?? "")
        _status = State(initialValue: invoice.status)
        _totalServices = State(initialValue: invoice.totalServices)
        _totalMaterials = State(initialValue: invoice.totalMaterials)
        _totalDivers = State(initialValue: invoice.totalDivers)
        _grandTotal = State(initialValue: invoice.grandTotal)
        _total = State(initialValue: invoice.total)
        _maxInterestsDate = State(initialValue: invoice.limitMaximumInterests ?? Date())
        
        if let _ = invoice.limitMaximumInterests,
           let maxInterests = invoice.maxInterests {
            _hasAnInterestsCeiling = State(initialValue: true)
            _maxInterestsValue = State(initialValue: "\(maxInterests)")
        } else {
            _hasAnInterestsCeiling = State(initialValue: false)
            _maxInterestsValue = State(initialValue: "")
        }
    }
    
    var body: some View {
        Form {
            ClientDetailsView(selectedClient: $client, canSelectUser: true)

            Section {
                TextField("Référence interne", text: $internalReference)
                TextField("Object", text: $object)
                DatePicker(selection: $facturationDate, displayedComponents: .date) {
                    Text("Date de facturation")
                }
                DatePicker(selection: $limitDate, displayedComponents: .date) {
                    Text("Date de validité")
                }
                Picker("Statut", selection: $status) {
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
                        maxInterestsValue = ""
                    } label: {
                        Text("Remove interest limit")
                    }
                    TextField("Maximum interests", text: $maxInterestsValue)
                        .keyboardType(.decimalPad)
//                    DatePicker("Limit maximum", selection: $maxLimitInterets,displayedComponents: .date)
                } else {
                    Button {
                        hasAnInterestsCeiling = true
                        maxInterestsValue = "0"
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
                                  total: $totalServices,
                                  sectionTitle: "Services",
                                  category: .service)
            ProductListUpdateView(products: $products,
                                  total: $totalMaterials,
                                  sectionTitle: "Materials",
                                  category: .material)
            ProductListUpdateView(products: $products,
                                  total: $totalDivers,
                                  sectionTitle: "Divers",
                                  category: .divers)

            TotalSectionView(totalService: totalServices,
                             totalMaterials: totalMaterials,
                             totalDivers: totalDivers,
                             total: total)
        }
        .onChange(of: products, perform: { newValue in
            total = 0
            newValue.forEach({ total += ($0.quantity * $0.price * ((100.0 - $0.reduction)/100.0)) })
        })
        .onChange(of: invoiceController.successUpdateInvoice, perform: { newValue in
            if newValue {
                invoiceController.successUpdateInvoice = false
                dismiss()
            }
        })
        .navigationTitle(reference)
        .toolbar {
            Button {
                var paymentID: UUID? = nil
                
                if payment.id != UUID(uuid: UUID_NULL) {
                    paymentID = payment.id
                }
                
                var limitMaximumInterests: String? = nil
                var maxInterestsUpdate: Double? = nil
                
                if hasAnInterestsCeiling {
                    limitMaximumInterests = maxInterestsDate.ISO8601Format()

                    if let maxInterestsDouble = Double(maxInterestsValue) {
                        maxInterestsUpdate = maxInterestsDouble
                    }
                }
                
                invoiceController.update(invoice: .init(id: id,
                                                        reference: reference,
                                                        internalReference: internalReference,
                                                        object: object,
                                                        totalServices: totalServices,
                                                        totalMaterials: totalMaterials,
                                                        totalDivers: totalDivers,
                                                        total: total,
                                                        grandTotal: grandTotal,
                                                        status: status,
                                                        limitPayementDate: limitDate.ISO8601Format(),
                                                        facturationDate: facturationDate.ISO8601Format(),
                                                        paymentID: paymentID,
                                                        comment: comment.isEmpty ? nil : comment,
                                                        limitMaximumInterests: limitMaximumInterests,
                                                        maxInterests: maxInterestsUpdate,
                                                        products: products.map({ $0.toUpdateDocuments()})),
                                         by: userController.connectedUser)
            } label: {
                Image(systemName: "v.circle")
            }
        }
    }
}

struct UpdateInvoiceView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UpdateInvoiceView(invoice: InvoicesManager.emptyInvoiceDetail)
            .environmentObject(InvoicesController(appController: AppController()))
            .environmentObject(UserController(appController: AppController()))
        }
    }
}
