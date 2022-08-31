//
//  TableColumnTitles.swift
//  Gestion
//
//  Created by Kevin Bertrand on 31/08/2022.
//

import SwiftUI

struct TableColumnTitles: View {
    var body: some View {
        HStack(spacing: 0) {
            Group {
                HStack {
                    Text("Désignation")
                    Spacer()
                }
                
                Group {
                    Text("Qté.")
                    Text("PU TTC")
                    Text("Mont. TTC")
                    Text("TVA")
                }.frame(width: 50, height: 50)
                    .multilineTextAlignment(.center)
            }
            .frame(height: 40)
            .padding(5)
            .border(.black)
            .background(Color("BackgroundTable"))
            .bold()
            .underline()
        }
    }
}

struct TableColumnTitles_Previews: PreviewProvider {
    static var previews: some View {
        TableColumnTitles()
    }
}
