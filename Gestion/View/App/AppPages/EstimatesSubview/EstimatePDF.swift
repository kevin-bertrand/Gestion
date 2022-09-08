//
//  EstimatePDF.swift
//  Gestion
//
//  Created by Kevin Bertrand on 31/08/2022.
//

import SwiftUI

struct EstimatePDF: View {
    let estimate: Estimate.Informations
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                PdfHeader(documentReference: "Devis \(estimate.reference)", date: "01/08/2022")
                
                HStack {
                    DesynticTile()
                    
                    Spacer()
                    
                    ClientTile(client: estimate.client)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Ref. interne: \(estimate.internalReference)")
                    Text("Objet: \(estimate.object)")
                }
                
                ProductTable(products: estimate.products, totalServices: estimate.totalServices, totalMaterials: estimate.totalMaterials, totalDivers: estimate.totalDivers)
                
                HStack(spacing: 10) {
                    VStack(alignment: .leading) {
                        Text("T.V.A. non applicable ou exonérée")
                        Text("Micro-entreprise, TVA non applicable en vertu de l'article 293 B du CGI")
                        Text("Date de validité: \(estimate.limitValidityDate.formatted(date: .numeric, time: .omitted))")
                        Text("Mode de règlement: Virement bancaire")
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 15) {
                        Text("Total HT.    \(estimate.grandTotal.twoDigitPrecision) €")
                        Text("Total TTC.   \(estimate.grandTotal.twoDigitPrecision) €")
                            .bold()
                    }.font(.footnote)
                }
                
                HStack() {
                    Text("Signature, précédée de la date et de la mention \"bon pour accord\":")
                    Spacer()
                }
                .frame(height: 150, alignment: .top)
                .padding()
                .border(.black)
            }
            .padding()
            .font(.caption)
        }
    }
}

struct EstimatePDF_Previews: PreviewProvider {
    static var previews: some View {
        EstimatePDF(estimate: EstimatesManager.emptyDetail)
    }
}
