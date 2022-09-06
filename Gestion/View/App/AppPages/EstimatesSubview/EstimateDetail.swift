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
            ClientDetailsView(selectedClient: .constant(ClientController.emptyClientInfo))
            
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
                    EstimatePDF(estimate: estimateController.selectedEstimate)
                        .toolbar {
                            Button {
                                estimateController.exportToPDF()
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
