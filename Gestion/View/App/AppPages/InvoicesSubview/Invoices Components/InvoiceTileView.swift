//
//  InvoiceTileView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 01/09/2022.
//

import SwiftUI

struct InvoiceTileView: View {
    let invoice: Invoice.Summary
    
    var body: some View {
        NavigationLink {
            InvoiceDetail(selectedInvoice: invoice.id)
        } label: {
            TileView(icon: "eurosign",
                     title: "\(invoice.reference)",
                     value: "\(invoice.grandTotal.twoDigitPrecision) €",
                     limit: "Limit: \(invoice.limitPayementDate.formatted(date: .numeric, time: .omitted))",
                     iconColor: getInvoiceColor(status: invoice.status))
        }
    }
    
    private func getInvoiceColor(status: InvoiceStatus) -> Color {
        switch status {
        case .inCreation:
            return .accentColor
        case .sent:
            return .gray
        case .payed:
            return .green
        case .overdue:
            return .red
        }
    }
}

struct InvoiceTileView_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceTileView(invoice: InvoicesController.emptySummaryInvoice)
    }
}
