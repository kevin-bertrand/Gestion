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
            Section {
                if let firstname = invoicesController.selectedInvoice.client.firstname,
                   let lastname = invoicesController.selectedInvoice.client.lastname {
                    Label("\(invoicesController.selectedInvoice.client.gender == .man ? "M " : ((invoicesController.selectedInvoice.client.gender == .woman) ? "Mme " : ""))\(firstname) \(lastname)", systemImage: "person.fill")
                }
                
                if let company = invoicesController.selectedInvoice.client.company {
                    Label("\(company)", systemImage: "building.2.fill")
                }
                
                Label("\(invoicesController.selectedInvoice.client.address.streetNumber) \(invoicesController.selectedInvoice.client.address.roadName)\n\(invoicesController.selectedInvoice.client.address.zipCode), \(invoicesController.selectedInvoice.client.address.city)\n\(invoicesController.selectedInvoice.client.address.country)", systemImage: "pin.fill")
                Label("\((invoicesController.selectedInvoice.client.email))", systemImage: "envelope.fill")
                Label("\(invoicesController.selectedInvoice.client.phone)", systemImage: "phone.fill")
                
                if let tva = invoicesController.selectedInvoice.client.tva {
                    Label("TVA: \(tva)", systemImage: "eurosign")
                }
                
                if let siret = invoicesController.selectedInvoice.client.siret {
                    Label("SIRET: \(siret)", systemImage: "person.badge.shield.checkmark.fill")
                }
            } header: {
                Text("Client informations")
            }
            
            Section("Payment information") {
                if let payment = invoicesController.selectedInvoice.payment {
                    Text("Title: \(payment.title)")
                    Text("BIC: \(payment.bic)")
                    Text("IBAN: \(payment.iban)")
                }
            }
            
            Section {
                Label("Limit: \(invoicesController.selectedInvoice.limitPayementDate.formatted(date: .numeric, time: .omitted))", systemImage: "hourglass")
                Label("Status \(invoicesController.selectedInvoice.status.rawValue)", systemImage: "list.triangle")
                
                if invoicesController.selectedInvoice.delayDays > 0 {
                    Label("Number of days delayed: \(invoicesController.selectedInvoice.delayDays)", systemImage: "hourglass")
                    Label("Total interests: \(invoicesController.selectedInvoice.totalDelay.twoDigitPrecision) €", systemImage: "eurosign")
                }
            } header: {
                Text("Invoice details")
            }
            
            Section {
                RevenueChartView(totalMaterials: invoicesController.selectedInvoice.totalMaterials,
                                 totalServices: invoicesController.selectedInvoice.totalServices,
                                 totalDivers: invoicesController.selectedInvoice.totalDivers)
            } header: {
                Text("Incomes")
            }
            
            Section {
                NavigationLink("Update") {
                    UpdateInvoiceView(invoice: invoicesController.selectedInvoice.toUpdate(),
                                      client: invoicesController.selectedInvoice.client,
                                      products: invoicesController.selectedInvoice.products)
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
