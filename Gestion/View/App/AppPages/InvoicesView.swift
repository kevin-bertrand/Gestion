//
//  InvoicesView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 30/08/2022.
//

import SwiftUI

struct InvoicesView: View {
    @EnvironmentObject var invoicesController: InvoicesController
    @EnvironmentObject var userController: UserController
    @State private var searchingText: String = ""
    
    var body: some View {
        List {
            Section {
                ForEach(invoicesController.invoicesList, id: \.reference) { invoice in
                    if invoice.status == .overdue {
                        InvoiceListTileView(invoice: invoice)
                    }
                }
            } header: {
                Text("Overdue invoices")
            }

            Section {
                ForEach(invoicesController.invoicesList, id: \.reference) { invoice in
                    if invoice.status == .inCreation {
                        InvoiceListTileView(invoice: invoice)
                    }
                }
            } header: {
                Text("In creation invoices")
            }
            
            Section {
                ForEach(invoicesController.invoicesList, id: \.reference) { invoice in
                    if invoice.status == .sent {
                        InvoiceListTileView(invoice: invoice)
                    }
                }
            } header: {
                Text("Sent invoices")
            }
            
            Section {
                ForEach(invoicesController.invoicesList, id: \.reference) { invoice in
                    if invoice.status == .payed {
                        InvoiceListTileView(invoice: invoice)
                    }
                }
            } header: {
                Text("Payed invoices")
            }
        }
        .searchable(text: $searchingText)
        .refreshable {
            invoicesController.downloadAllInvoicesSummary(for: userController.connectedUser)
        }
        .navigationTitle("Invoices")
        .toolbar {
            NavigationLink {
                AddInvoiceView()
            } label: {
                Image(systemName: "plus.circle")
            }
        }
        .onAppear {
            invoicesController.downloadAllInvoicesSummary(for: userController.connectedUser)
        }
    }
}

struct InvoicesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            InvoicesView()
                .environmentObject(InvoicesController(appController: AppController()))
                .environmentObject(UserController(appController: AppController()))
        }
    }
}
