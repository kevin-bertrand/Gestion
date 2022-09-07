//
//  PaymentTileView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 07/09/2022.
//

import SwiftUI

struct PaymentTileView: View {
    let payment: Payment
    var body: some View {
        VStack(alignment: .leading) {
            Text(payment.title)
                .font(.title2.bold())
            Text("IBAN: \(payment.iban)")
        }
    }
}

struct PaymentTileView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentTileView(payment: Payment(id: UUID(uuid: UUID_NULL), title: "", iban: "", bic: ""))
    }
}
