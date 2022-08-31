//
//  InvoicePDF.swift
//  Gestion
//
//  Created by Kevin Bertrand on 31/08/2022.
//

import SwiftUI

struct InvoicePDF: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                PdfHeader(documentReference: "Facture F-202208-001", date: "01/08/2022")
                
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
                
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Date d'échéance: 01/08/2022")
                        Text("Mode de règlement: Virement bancaire")
                        
                        VStack(alignment: .leading) {
                            Text("Coordonées bancaires :")
                            Text("Bourorama Banque")
                                .bold()
                            
                            HStack(spacing: 2) {
                                Text("IBAN :")
                                Text("FR12 3456 7890 1234 5678 9012 123")
                                    .bold()
                            }
                            HStack(spacing: 2) {
                                Text("BIC :")
                                Text("AZER FRDD XXX")
                                    .bold()
                            }
                        }
                        .padding(5)
                        .border(.black)
                    }
                                        
                    VStack(alignment: .trailing, spacing: 15) {
                        Text("Total HT.    150 €")
                        Text("Total TTC.   150 €")
                            .bold()
                    }.font(.footnote)
                }
                
                HStack() {
                    Text("Micro-entreprise - TVA non-applicable, art. 239 B du CGI.")
                    Spacer()
                }
                .padding(5)
                .border(.black)
                
                Divider()
                
                Text("Pas d'escompte pour paiement anticipé. Passée la date d'échéance, tout paiement différé entraine l'application d'une pénalité de 3 fois le taux d'intérêt légal (loi 2008-776 du 04/08/2008) ainsi qu'une indemnité forfaitaire pour frais de recouvrement de 40 euros (Décret 2012-1115 du 02/10/2012).")
            }
            .padding()
            .font(.caption)
        }
    }
}

struct InvoicePDF_Previews: PreviewProvider {
    static var previews: some View {
        InvoicePDF()
    }
}
