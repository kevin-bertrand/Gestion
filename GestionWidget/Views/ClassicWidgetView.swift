//
//  ClassicWidgetView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 05/12/2022.
//

import SwiftUI

struct SmallWidget: View {
    @State private var estimatesInWait = 3
    @State private var invoicesInWait = 4
    @State private var invoiceUnPaid = 1
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Image("Logo")
                    .resizable()
                    .frame(width: 30, height: 40)
                Spacer()
                Text("Suivi des factures")
                    .bold()
            }
            .padding()
               
            VStack {
                Text("Factures en attente:")
                Text("\(estimatesInWait)")
                    .bold()
                    .foregroundColor(estimatesInWait == 0 ? .green : .orange)
                
                Divider()
                
                Text("Factures non payées:")
                Text("\(estimatesInWait)")
                    .bold()
                    .foregroundColor(invoiceUnPaid == 0 ? .green : .red)
            }
        }
        .font(.caption)
        .padding()
    }
}

struct ClassicWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        SmallWidget()
    }
}
