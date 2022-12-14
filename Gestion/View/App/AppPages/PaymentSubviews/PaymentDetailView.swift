//
//  PaymentDetailView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 07/09/2022.
//

import SwiftUI

struct PaymentDetailView: View {
    @State var payment: Payment
    
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
                PaymentUpdateView(payment: $payment)
            } label: {
                Image(systemName: "pencil.circle")
            }
        }
    }
}

struct PaymentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentDetailView(payment: PaymentController.emptyPayment)
    }
}
