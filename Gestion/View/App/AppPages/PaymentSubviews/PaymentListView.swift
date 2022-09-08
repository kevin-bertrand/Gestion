//
//  PaymentListView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 07/09/2022.
//

import SwiftUI

struct PaymentListView: View {
    @EnvironmentObject var userController: UserController
    @EnvironmentObject var paymentController: PaymentController
    
    var body: some View {
        List {
            ForEach(paymentController.payments, id: \.id) { payment in
                NavigationLink {
                    PaymentDetailView(payment: payment)
                } label: {
                    PaymentTileView(payment: payment)
                }
            }
        }
        .navigationTitle("Payments List")
        .onAppear {
            paymentController.gettingAllMethods(by: userController.connectedUser)
        }
        .toolbar {
            NavigationLink {
                PaymentCreateView()
            } label: {
                Image(systemName: "plus.circle")
            }
        }
    }
}

struct PaymentListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PaymentListView()
                .environmentObject(UserController(appController: AppController()))
                .environmentObject(PaymentController(appController: AppController()))
        }
    }
}
