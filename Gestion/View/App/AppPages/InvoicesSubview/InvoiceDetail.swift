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
            } header: {
                Text("Invoice details")
            }
            
            Section {
                RevenueChartView(totalMaterials: invoicesController.selectedInvoice.totalMaterials, totalServices: invoicesController.selectedInvoice.totalServices, totalDivers: invoicesController.selectedInvoice.totalDivers)
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
