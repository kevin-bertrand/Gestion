//
//  EstimatePDF.swift
//  Gestion
//
//  Created by Kevin Bertrand on 31/08/2022.
//

import SwiftUI

struct EstimatePDF: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                PdfHeader(documentReference: "Devis D-202208-001", date: "01/08/2022")
                
                HStack {
                    DesynticTile()
                    
                    Spacer()
                    
                    ClientTile()
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Ref. interne: EL22001")
                    Text("Objet: Installation")
                }
                
                VStack(spacing: 0) {
                    TableColumnTitles()
                    TableSectionTitle(title: "Services")
                    TableRow(title: "Installation", quantity: 1, unity: "jours", unitaryPrice: 150)
                    TotalSectionLine(section: "Services", total: 150)
                    TableSectionTitle(title: "Matériel")
                    TotalSectionLine(section: "Matériel", total: 0)
                    TableSectionTitle(title: "Divers")
                    TotalSectionLine(section: "Divers", total: 0)
                }
                
                HStack(spacing: 10) {
                    VStack(alignment: .leading) {
                        Text("T.V.A. non applicable ou exonérée")
                        Text("Micro-entreprise, TVA non applicable en vertu de l'article 293 B du CGI")
                        Text("Date de validité: 01/08/2022")
                        Text("Mode de règlement: Virement bancaire")
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 15) {
                        Text("Total HT.    150 €")
                        Text("Total TTC.   150 €")
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
        EstimatePDF()
    }
}
