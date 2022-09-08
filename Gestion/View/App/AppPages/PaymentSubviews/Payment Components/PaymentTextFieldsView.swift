//
//  PaymentTextFieldsView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 08/09/2022.
//

import SwiftUI

struct PaymentTextFieldsView: View {
    @Binding var payment: Payment
    
    var body: some View {
        Form {
            Section {
                TextField("Title", text: $payment.title)
                TextField("IBAN", text: $payment.iban)
                TextField("BIC", text: $payment.bic)
            }
        }
    }
}

struct PaymentTextFieldsView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentTextFieldsView(payment: .constant(PaymentController.emptyPayment))
    }
}
