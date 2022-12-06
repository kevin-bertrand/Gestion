//
//  SmallWidget.swift
//  Gestion
//
//  Created by Kevin Bertrand on 05/12/2022.
//

import SwiftUI

struct SmallWidget: View {
    @State var data: Widgets
    
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
                Text("\(data.invoiceInWaiting)")
                    .bold()
                    .foregroundColor(data.invoiceInWaiting == 0 ? .green : .orange)
                
                Divider()
                
                Text("Factures non payées:")
                Text("\(data.invoiceUnPaid)")
                    .bold()
                    .foregroundColor(data.invoiceUnPaid == 0 ? .green : .red)
            }
        }
        .font(.caption)
        .padding()
    }
}

struct ClassicWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        SmallWidget(data: Widgets(yearRevenues: 0, monthRevenues: 0, estimatesInCreation: 0, estimatesInWaiting: 0, invoiceInWaiting: 0, invoiceUnPaid: 0))
    }
}
