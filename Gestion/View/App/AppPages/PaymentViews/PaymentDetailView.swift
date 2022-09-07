//
//  PaymentDetailView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 07/09/2022.
//

import SwiftUI

struct PaymentDetailView: View {
    let payment: Payment
    
    var body: some View {
        Form {
            Section {
                Text("Title: \(payment.title)")
                Text("BIC: \(payment.bic)")
                Text("IBAN: \(payment.iban)")
            }
        }
        .navigationTitle("Details")
        .toolbar {
            NavigationLink {
                
            } label: {
                Image(systemName: "pencil.circle")
            }
        }
    }
}

struct PaymentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentDetailView(payment: Payment(id: UUID(uuid: UUID_NULL), title: "", iban: "", bic: ""))
    }
}
