//
//  PaymentUpdateView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 07/09/2022.
//

import SwiftUI

struct PaymentUpdateView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject private var paymentController: PaymentController
    @EnvironmentObject private var userController: UserController
    
    @Binding var payment: Payment
    @State private var updatedPayment: Payment = PaymentController.emptyPayment
    
    var body: some View {
        PaymentTextFieldsView(payment: $updatedPayment)
        .navigationTitle("Update")
        .toolbar {
            Button {
                paymentController.update(method: updatedPayment, by: userController.connectedUser)
            } label: {
                Image(systemName: "v.circle")
            }
        }
        .onAppear {
            updatedPayment = payment
        }
        .onChange(of: paymentController.paymentIsUpdated) { newValue in
            if newValue {
                payment = updatedPayment
                paymentController.paymentIsUpdated = false
                dismiss()
            }
        }
    }
}

struct PaymentUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentUpdateView(payment: .constant(PaymentController.emptyPayment))
            .environmentObject(UserController(appController: AppController()))
            .environmentObject(PaymentController(appController: AppController()))
    }
}
