//
//  InvoicesView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 30/08/2022.
//

import SwiftUI

struct InvoicesView: View {
    @State private var invoiceList: [String] = ["Invoice 1", "Invoice 2"]
    @State private var searchingText: String = ""
    
    var body: some View {
        List {
            ForEach(invoiceList, id: \.self) { invoice in
//                InvoiceTileView(invoice: invoice)
            }
        }
        .searchable(text: $searchingText)
        .refreshable {
            // TODO: Refresh list
        }
        .navigationTitle("Invoices")
        .toolbar {
            NavigationLink {
                AddInvoiceView()
            } label: {
                Image(systemName: "plus.circle")
            }
        }
    }
}

struct InvoicesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            InvoicesView()
        }
    }
}
