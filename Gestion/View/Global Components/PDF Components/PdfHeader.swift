//
//  PdfHeader.swift
//  Gestion
//
//  Created by Kevin Bertrand on 31/08/2022.
//

import SwiftUI

struct PdfHeader: View {
    let documentReference: String
    let date: String
    
    var body: some View {
        HStack {
            Image("Logo-Name")
                .resizable()
                .frame(width: 150, height: 75)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 15) {
                Text(documentReference)
                    .font(.callout)
                    .bold()
                Text("Date: \(date)")
            }
        }.padding(.bottom)
    }
}

struct PdfHeader_Previews: PreviewProvider {
    static var previews: some View {
        PdfHeader(documentReference: "Devis D-202208-001", date: "01/08/2022")
    }
}
