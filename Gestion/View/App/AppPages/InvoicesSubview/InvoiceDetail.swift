//
//  InvoiceDetail.swift
//  Gestion
//
//  Created by Kevin Bertrand on 31/08/2022.
//

import SwiftUI

struct InvoiceDetail: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var invoicesController: InvoicesController
    @EnvironmentObject var userController: UserController
    
    @State private var showAlert: Bool = false
    
    let selectedInvoice: UUID?
    
    var body: some View {
        List {
            ClientDetailsView(selectedClient: .constant(invoicesController.selectedInvoice.client))
            
            Section("Payment information") {
                if let payment = invoicesController.selectedInvoice.payment {
                    Text("Title: \(payment.title)")
                    Text("BIC: \(payment.bic)")
                    Text("IBAN: \(payment.iban)")
                }
            }
            
            Section {
                Label("Internal ref: \(invoicesController.selectedInvoice.internalReference)", systemImage: "doc.text")
                Label("Object: \(invoicesController.selectedInvoice.object)", systemImage: "doc.text")
                Label("Facturation: \(invoicesController.selectedInvoice.facturationDate.formatted(date: .numeric, time: .omitted))", systemImage: "hourglass")
                Label("Limit: \(invoicesController.selectedInvoice.limitPayementDate.formatted(date: .numeric, time: .omitted))", systemImage: "hourglass")
                Label("Status \(invoicesController.selectedInvoice.status.rawValue)", systemImage: "list.triangle")
            } header: {
                Text("Invoice details")
            }
            
            
            if invoicesController.selectedInvoice.delayDays > 0 {
                Section {
                    Label("Number of days delayed: \(invoicesController.selectedInvoice.delayDays)", systemImage: "hourglass")
                    Label("Total interests: \(invoicesController.selectedInvoice.totalDelay.twoDigitPrecision) €", systemImage: "eurosign")
                    
                    if let maxInterests = invoicesController.selectedInvoice.maxInterests,
                       let maxInterestsLimit = invoicesController.selectedInvoice.limitMaximumInterests {
                        Label("Maximum interests: \(maxInterests.twoDigitPrecision) €", systemImage: "eurosign")
                        Label("Limit max interests: \(maxInterestsLimit.formatted(date: .numeric, time: .omitted))", systemImage: "hourglass")
                    }
                } header: {
                    Text("Interests")
                }
            }
            
            if let comments = invoicesController.selectedInvoice.comment {
                Section {
                    Text(comments)
                } header: {
                    Text("Comments")
                }
            }
            
            Section {
                RevenueChartView(totalMaterials: invoicesController.selectedInvoice.totalMaterials,
                                 totalServices: invoicesController.selectedInvoice.totalServices,
                                 totalDivers: invoicesController.selectedInvoice.totalDivers)
            } header: {
                Text("Incomes")
            }
            
            Section {
                if invoicesController.selectedInvoice.status != .payed {
                    NavigationLink("Update") {
                        UpdateInvoiceView(invoice: invoicesController.selectedInvoice)
                    }
                }
                
                NavigationLink("Show PDF") {
                    PDFUIView(pdf: invoicesController.invoicePDF)
                }
                
                if invoicesController.selectedInvoice.status != .payed {
                    Button {
                        showAlert = true
                    } label: {
                        Text("Set to payed")
                    }
                }
            } header: {
                Text("Actions")
            }
        }
        .navigationTitle(invoicesController.selectedInvoice.reference)
        .onAppear {
            if let id = selectedInvoice {
                invoicesController.selectInvoice(id: id, by: userController.connectedUser)
            } else {
                dismiss()
            }
        }
        .onChange(of: invoicesController.isPayed) { newValue in
            if newValue {
                invoicesController.isPayed = false
                dismiss()
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("This invoice is paied?"), message: nil, primaryButton: .default(Text("Yes"), action:{
                invoicesController.invoiceIsPaied(by: userController.connectedUser)
            }), secondaryButton: .cancel())
        }
    }
}

struct InvoiceDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            InvoiceDetail(selectedInvoice: UUID(uuid: UUID_NULL))
                .environmentObject(InvoicesController(appController: AppController()))
                .environmentObject(UserController(appController: AppController()))
        }
    }
}
