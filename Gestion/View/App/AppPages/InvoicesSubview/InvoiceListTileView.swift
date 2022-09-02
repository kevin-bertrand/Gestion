//
//  InvoiceListTileView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 02/09/2022.
//

import SwiftUI

struct InvoiceListTileView: View {
    let invoice: Invoice.Summary
    
    var body: some View {
        NavigationLink {
            InvoiceDetail(selectedInvoice: invoice.id)
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                Text(invoice.reference)
                Text("\(invoice.grandTotal.twoDigitPrecision) €")
                    .foregroundColor(.gray)
                    .font(.callout)
                Text(invoice.limitPayementDate.formatted(date: .numeric, time: .omitted))
                    .foregroundColor(.gray)
                    .font(.callout)
            }
        }
    }
}

struct InvoiceListTileView_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceListTileView(invoice: Invoice.Summary(id: nil, client: Client.Summary(firstname: "", lastname: "", company: ""), reference: "", grandTotal: 0, status: .inCreation, limitPayementDate: Date(), isArchive: true))
    }
}
