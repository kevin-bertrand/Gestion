//
//  InvoiceDetail.swift
//  Gestion
//
//  Created by Kevin Bertrand on 31/08/2022.
//

import SwiftUI

struct InvoiceDetail: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        List {
            Section {
                Label("Name", systemImage: "person.fill")
                Label("Address", systemImage: "pin.fill")
                Label("Email", systemImage: "envelope.fill")
                Label("Phone", systemImage: "phone.fill")
                Label("TVA", systemImage: "eurosign")
                Label("SIRET", systemImage: "person.badge.shield.checkmark.fill")
            } header: {
                Text("Client informations")
            }
            
            Section {
                Label("Creation date", systemImage: "calendar")
                Label("Limit", systemImage: "hourglass")
                Label("Status", systemImage: "list.triangle")
            } header: {
                Text("Invoice details")
            }
            
            Section {
                PieChartView(values: [1, 20], names: ["Materials", "Services"], formatter: { number in
                    return "\(number)"
                }, colorScheme: colorScheme)
                .frame(height: 375)
            } header: {
                Text("Incomes")
            }
            
            Section {
                NavigationLink("Update") {
                    UpdateInvoiceView()
                        .toolbar {
                            Button {
                                // TODO: Save changes
                            } label: {
                                Image(systemName: "v.circle")
                            }

                        }
                }
                NavigationLink("Show PDF") {
                    InvoicePDF()
                        .toolbar {
                            Button {
                                // TODO: Share
                            } label: {
                                Image(systemName: "square.and.arrow.up")
                            }
                        }
                        .navigationBarTitleDisplayMode(.inline)
                }
            } header: {
                Text("Actions")
            }
        }.navigationTitle("F-202208-001")
    }
}

struct InvoiceDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            InvoiceDetail()
        }
    }
}
