//
//  TableRow.swift
//  Gestion
//
//  Created by Kevin Bertrand on 31/08/2022.
//

//import SwiftUI
//
//struct TableRow: View {
//    let title: String
//    let quantity: Double
//    let unity: String
//    let unitaryPrice: Double
//    
//    var body: some View {
//        HStack(alignment: .top, spacing: 0) {
//            Group {
//                HStack {
//                    Text(title)
//                    Spacer()
//                }.frame(minWidth: 100)
//                
//                Group {
//                    Text("\(quantity.twoDigitPrecision) \(unity)")
//                    Text("\(unitaryPrice.twoDigitPrecision) €")
//                    Text("\((quantity * unitaryPrice).twoDigitPrecision) €")
//                    Text("0.0 %")
//                }.frame(width: 70, height: 50)
//                    .multilineTextAlignment(.center)
//            }
//            .frame(height: 40)
//            .padding(5)
//            .border(.black)
//        }
//    }
//}
//
//struct TableRow_Previews: PreviewProvider {
//    static var previews: some View {
//        TableRow(title: "", quantity: 0.0, unity: "", unitaryPrice: 0.0)
//    }
//}
