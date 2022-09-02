//
//  EstimateDetail.swift
//  Gestion
//
//  Created by Kevin Bertrand on 02/09/2022.
//

import SwiftUI

struct EstimateDetail: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var estimateController: EstimatesController
    @EnvironmentObject var userController: UserController
    
    let selectedEstimate: UUID?
    
    var body: some View {
        List {
            Section {
                if let firstname = estimateController.selectedEstimate.client.firstname,
                   let lastname = estimateController.selectedEstimate.client.lastname {
                    Label("\(estimateController.selectedEstimate.client.gender == .man ? "M " : ((estimateController.selectedEstimate.client.gender == .woman) ? "Mme " : ""))\(firstname) \(lastname)", systemImage: "person.fill")
                }
                
                if let company = estimateController.selectedEstimate.client.company {
                    Label("\(company)", systemImage: "building.2.fill")
                }
                
                Label("\(estimateController.selectedEstimate.client.address.streetNumber) \(estimateController.selectedEstimate.client.address.roadName)\n\(estimateController.selectedEstimate.client.address.zipCode), \(estimateController.selectedEstimate.client.address.city)\n\(estimateController.selectedEstimate.client.address.country)", systemImage: "pin.fill")
                Label("\((estimateController.selectedEstimate.client.email))", systemImage: "envelope.fill")
                Label("\(estimateController.selectedEstimate.client.phone)", systemImage: "phone.fill")
                
                if let tva = estimateController.selectedEstimate.client.tva {
                    Label("TVA: \(tva)", systemImage: "eurosign")
                }

                if let siret = estimateController.selectedEstimate.client.siret {
                    Label("SIRET: \(siret)", systemImage: "person.badge.shield.checkmark.fill")
                }
            } header: {
                Text("Client informations")
            }
            
            Section {
//                Label("Creation date", systemImage: "calendar")
                Label("Limit: \(estimateController.selectedEstimate.limitValidityDate.formatted(date: .numeric, time: .omitted))", systemImage: "hourglass")
                Label("Status \(estimateController.selectedEstimate.status.rawValue)", systemImage: "list.triangle")
            } header: {
                Text("Invoice details")
            }
            
            Section {
                PieChartView(values: [estimateController.selectedEstimate.totalMaterials, estimateController.selectedEstimate.totalServices, estimateController.selectedEstimate.totalDivers], names: ["Materials", "Services", "Divers"], formatter: { number in
                    return "\(number)"
                }, colorScheme: colorScheme)
                .frame(height: 420)
            } header: {
                Text("Incomes")
            }
            
            Section {
                NavigationLink("Update") {
                    Text("Update")
                        .toolbar {
                            Button {
                                // TODO: Save changes
                            } label: {
                                Image(systemName: "v.circle")
                            }

                        }
                }
                NavigationLink("Show PDF") {
                    EstimatePDF()
                        .toolbar {
                            Button {
                                // TODO: Export to PDF
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
        .navigationTitle(estimateController.selectedEstimate.reference)
        .onAppear {
            if let id = selectedEstimate {
                estimateController.downloadEstimateDetail(id: id, by: userController.connectedUser)
            } else {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct EstimateDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EstimateDetail(selectedEstimate: nil)
                .environmentObject(UserController(appController: AppController()))
                .environmentObject(EstimatesController(appController: AppController()))
        }
    }
}
