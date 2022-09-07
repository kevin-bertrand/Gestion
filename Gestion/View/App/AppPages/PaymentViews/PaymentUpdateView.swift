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
    @State private var updatedPayment: Payment = Payment(id: UUID(uuid: UUID_NULL), title: "", iban: "", bic: "")
    
    var body: some View {
        Form {
            Section {
                TextField("Title", text: $updatedPayment.title)
                TextField("IBAN", text: $updatedPayment.iban)
                TextField("BIC", text: $updatedPayment.bic)
            }
        }
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
        PaymentUpdateView(payment: .constant(Payment(id: UUID(uuid: UUID_NULL), title: "", iban: "", bic: "")))
            .environmentObject(UserController(appController: AppController()))
            .environmentObject(PaymentController(appController: AppController()))
    }
}
