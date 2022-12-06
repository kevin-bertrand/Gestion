//
//  MediumWidget.swift
//  Gestion
//
//  Created by Kevin Bertrand on 05/12/2022.
//

import SwiftUI

struct MediumWidget: View {
    @State var data: Widgets
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Image("Logo")
                    .resizable()
                    .frame(width: 30, height: 40)
                Spacer()
                
                Group {
                    VStack {
                        Text("CA mensuel")
                        Text("\(data.monthRevenues.twoDigitPrecision) €")
                            .foregroundColor(data.monthRevenues > 0 ? .green : .red)
                    }
                    Divider()
                    VStack {
                        Text("CA annuel")
                        Text("\(data.yearRevenues.twoDigitPrecision) €")
                            .foregroundColor(data.yearRevenues > 0 ? .green : .red)
                    }
                }
                .padding(.horizontal)
                .font(.footnote)
            }
            .padding()
            
            
            Group {
                HStack {
                    VStack {
                        Text("Devis en création:")
                        Text("\(data.estimatesInCreation)")
                            .bold()
                            .foregroundColor(data.estimatesInCreation == 0 ? .green : .orange)
                        
                        Divider()
                        
                        Text("Devis en attente:")
                        Text("\(data.estimatesInWaiting)")
                            .bold()
                            .foregroundColor(data.estimatesInWaiting == 0 ? .green : .red)
                    }
                    
                    Divider()
                    
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
            }
            .font(.caption)
        }
        .padding()
    }
}

struct MediumWidget_Previews: PreviewProvider {
    static var previews: some View {
        MediumWidget(data: Widgets(yearRevenues: 0, monthRevenues: 0, estimatesInCreation: 0, estimatesInWaiting: 0, invoiceInWaiting: 0, invoiceUnPaid: 0))
    }
}
