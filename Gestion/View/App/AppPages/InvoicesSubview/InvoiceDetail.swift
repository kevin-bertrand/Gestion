//
//  InvoiceDetail.swift
//  Gestion
//
//  Created by Kevin Bertrand on 31/08/2022.
//

import SwiftUI

struct InvoiceDetail: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var invoicesController: InvoicesController
    @EnvironmentObject var userController: UserController
    
    let selectedInvoice: UUID?
    
    var body: some View {
        List {
            Section {
                if let firstname = invoicesController.selectedInvoice.client.firstname,
                   let lastname = invoicesController.selectedInvoice.client.lastname {
                    Label("\(invoicesController.selectedInvoice.client.gender == .man ? "M " : ((invoicesController.selectedInvoice.client.gender == .woman) ? "Mme " : ""))\(firstname) \(lastname)", systemImage: "person.fill")
                }
                
                if let company = invoicesController.selectedInvoice.client.company {
                    Label("\(company)", systemImage: "building.2.fill")
                }
                
                Label("\(invoicesController.selectedInvoice.client.address.streetNumber) \(invoicesController.selectedInvoice.client.address.roadName)\n\(invoicesController.selectedInvoice.client.address.zipCode), \(invoicesController.selectedInvoice.client.address.city)\n\(invoicesController.selectedInvoice.client.address.country)", systemImage: "pin.fill")
                Label("\((invoicesController.selectedInvoice.client.email))", systemImage: "envelope.fill")
                Label("\(invoicesController.selectedInvoice.client.phone)", systemImage: "phone.fill")
                
                if let tva = invoicesController.selectedInvoice.client.tva {
                    Label("TVA: \(tva)", systemImage: "eurosign")
                }

                if let siret = invoicesController.selectedInvoice.client.siret {
                    Label("SIRET: \(siret)", systemImage: "person.badge.shield.checkmark.fill")
                }
            } header: {
                Text("Client informations")
            }
            
            Section {
//                Label("Creation date", systemImage: "calendar")
                Label("Limit: \(invoicesController.selectedInvoice.limitPayementDate.formatted(date: .numeric, time: .omitted))", systemImage: "hourglass")
                Label("Status \(invoicesController.selectedInvoice.status.rawValue)", systemImage: "list.triangle")
            } header: {
                Text("Invoice details")
            }
            
            Section {
                PieChartView(values: [invoicesController.selectedInvoice.totalMaterials, invoicesController.selectedInvoice.totalServices, invoicesController.selectedInvoice.totalDivers], names: ["Materials", "Services", "Divers"], formatter: { number in
                    return "\(number)"
                }, colorScheme: colorScheme)
                .frame(height: 420)
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
                    InvoicePDF(invoice: invoicesController.selectedInvoice)
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
        }
        .navigationTitle(invoicesController.selectedInvoice.reference)
        .onAppear {
            if let id = selectedInvoice {
                invoicesController.selectInvoice(id: id, by: userController.connectedUser)
            } else {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct InvoiceDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            InvoiceDetail(selectedInvoice: UUID(uuid: UUID_NULL))
                .environmentObject(InvoicesController(appController: AppController()))
                .environmentObject(UserController(appController: AppController()))
        }
    }
}
