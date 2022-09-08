//
//  PaymentCreateView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 07/09/2022.
//

import SwiftUI

struct PaymentCreateView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject private var paymentController: PaymentController
    @EnvironmentObject private var userController: UserController
    
    @State private var newPayment: Payment.Create = PaymentController.emptyCreatePayment
    
    var body: some View {
        PaymentTextFieldsView(payment: .init(get: {
            .init(id: UUID(uuid: UUID_NULL), title: newPayment.title, iban: newPayment.iban, bic: newPayment.bic)
        }, set: {
            newPayment.title = $0.title
            newPayment.bic = $0.bic
            newPayment.iban = $0.iban
        }))
        .navigationTitle("Update")
        .toolbar {
            Button {
                paymentController.create(method: newPayment, by: userController.connectedUser)
            } label: {
                Image(systemName: "v.circle")
            }
        }
        .onChange(of: paymentController.paymentIsCreate) { newValue in
            if newValue {
                paymentController.paymentIsCreate = false
                dismiss()
            }
        }
    }
}

struct PaymentCreateView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentCreateView()
    }
}
