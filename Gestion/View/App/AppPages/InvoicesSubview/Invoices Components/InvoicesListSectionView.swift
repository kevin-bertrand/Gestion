//
//  InvoicesListSectionView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 08/09/2022.
//

import SwiftUI

struct InvoicesListSectionView: View {
    let list: [Invoice.Summary]
    let title: String
    let status: InvoiceStatus
    
    var body: some View {
        Section {
            ForEach(list, id: \.reference) { invoice in
                if invoice.status == status {
                    InvoiceListTileView(invoice: invoice)
                }
            }
        } header: {
            Text(title)
        }
    }
}

struct InvoicesListSectionView_Previews: PreviewProvider {
    static var previews: some View {
        InvoicesListSectionView(list: [], title: "", status: .inCreation)
    }
}
