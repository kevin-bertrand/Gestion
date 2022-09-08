//
//  InvoicePDF.swift
//  Gestion
//
//  Created by Kevin Bertrand on 31/08/2022.
//

import SwiftUI

struct InvoicePDF: View {
    let invoice: Invoice.Informations
    
    var body: some View {
        ScrollView() {
            VStack(alignment: .leading, spacing: 15) {
                PdfHeader(documentReference: "\(invoice.reference)", date: "01/08/2022")
                
                HStack {
                    DesynticTile()
                    
                    Spacer()
                    
                    ClientTile(client: invoice.client)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Ref. interne: \(invoice.internalReference)")
                    Text("Objet: \(invoice.object)")
                }
                
                ProductTable(products: invoice.products, totalServices: invoice.totalServices, totalMaterials: invoice.totalMaterials, totalDivers: invoice.totalDivers)
                
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Date d'échéance: \(invoice.limitPayementDate.formatted(date: .numeric, time: .omitted))")
                        Text("Mode de règlement: Virement bancaire")
                        
                        if let payment = invoice.payment {
                            VStack(alignment: .leading) {
                                Text("Coordonées bancaires :")
                                Text("\(payment.title)")
                                    .bold()
                                
                                HStack(spacing: 2) {
                                    Text("IBAN :")
                                    Text("\(payment.iban)")
                                        .bold()
                                }
                                HStack(spacing: 2) {
                                    Text("BIC :")
                                    Text("\(payment.bic)")
                                        .bold()
                                }
                            }
                            .padding(5)
                            .border(.black)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 15) {
                        Text("Total HT.    \(invoice.grandTotal.twoDigitPrecision) €")
                        Text("Total TTC.   \(invoice.grandTotal.twoDigitPrecision) €")
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
        InvoicePDF(invoice: InvoicesManager.emptyInvoiceDetail)
    }
}
