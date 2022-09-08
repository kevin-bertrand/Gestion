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
            InvoicesListSectionView(list: invoicesController.invoicesList, title: "Overdue invoices", status: .overdue)
            InvoicesListSectionView(list: invoicesController.invoicesList, title: "In creation invoices", status: .inCreation)
            InvoicesListSectionView(list: invoicesController.invoicesList, title: "Sent invoices", status: .sent)
            InvoicesListSectionView(list: invoicesController.invoicesList, title: "Payed invoices", status: .payed)
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
