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
    
    @State private var newPayment: Payment = Payment(id: UUID(uuid: UUID_NULL), title: "", iban: "", bic: "")
    
    var body: some View {
        Form {
            Section {
                TextField("Title", text: $newPayment.title)
                TextField("IBAN", text: $newPayment.iban)
                TextField("BIC", text: $newPayment.bic)
            }
        }
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
