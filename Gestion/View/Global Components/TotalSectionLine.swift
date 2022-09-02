//
//  TotalSectionLine.swift
//  Gestion
//
//  Created by Kevin Bertrand on 31/08/2022.
//

import SwiftUI

struct TotalSectionLine: View {
    let section: String
    let total: Double
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Group {
                HStack {
                    Text("Total \(section)")
                    Spacer()
                }.frame(minWidth: 100)
                
                Group {
                    Group {
                        Rectangle()
                        Rectangle()
                    }
                    .foregroundColor(Color("UnusedBackgroundTable"))
                    .padding(.horizontal, -5)
                    
                    Text("\(total.twoDigitPrecision) €")
                    
                    Rectangle()                                    .foregroundColor(Color("UnusedBackgroundTable"))
                        .padding(.horizontal, -5)
                }.frame(width: 70, height: 50)
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

struct TotalSectionLine_Previews: PreviewProvider {
    static var previews: some View {
        TotalSectionLine(section: "", total: 0)
    }
}
