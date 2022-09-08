//
//  SelectPaymentListView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 07/09/2022.
//

import SwiftUI

struct SelectPaymentListView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var userController: UserController
    @EnvironmentObject var paymentController: PaymentController
    
    @Binding var selectedPayment: Payment
    
    var body: some View {
        List {
            ForEach(paymentController.payments, id: \.id) { payment in
                PaymentTileView(payment: payment)
                    .onTapGesture {
                        selectedPayment = payment
                        dismiss()
                    }
            }
        }
        .navigationTitle("Payments")
        .onAppear {
            paymentController.gettingAllMethods(by: userController.connectedUser)
        }
    }
}

struct SelectPaymentListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SelectPaymentListView(selectedPayment: .constant(PaymentController.emptyPayment))
                .environmentObject(UserController(appController: AppController()))
                .environmentObject(PaymentController(appController: AppController()))
        }
    }
}
