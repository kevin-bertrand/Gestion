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
            ClientDetailsView(selectedClient: .constant(estimateController.selectedEstimate.client))
            
            Section {
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
                    UpdateEstimateView(estimate: Estimate.Update(id: estimateController.selectedEstimate.id,
                                                                 reference: estimateController.selectedEstimate.reference,
                                                                 internalReference: estimateController.selectedEstimate.internalReference,
                                                                 object: estimateController.selectedEstimate.object,
                                                                 totalServices: estimateController.selectedEstimate.totalServices,
                                                                 totalMaterials: estimateController.selectedEstimate.totalMaterials,
                                                                 totalDivers: estimateController.selectedEstimate.totalDivers,
                                                                 total: estimateController.selectedEstimate.total,
                                                                 reduction: estimateController.selectedEstimate.reduction,
                                                                 grandTotal: estimateController.selectedEstimate.grandTotal,
                                                                 status: estimateController.selectedEstimate.status,
                                                                 products: []),
                                       client: Client.Informations(id: estimateController.selectedEstimate.client.id,
                                                                   firstname: estimateController.selectedEstimate.client.firstname,
                                                                   lastname: estimateController.selectedEstimate.client.lastname,
                                                                   company: estimateController.selectedEstimate.client.company,
                                                                   phone: estimateController.selectedEstimate.client.phone,
                                                                   email: estimateController.selectedEstimate.client.email,
                                                                   personType: estimateController.selectedEstimate.client.personType,
                                                                   gender: estimateController.selectedEstimate.client.gender,
                                                                   siret: estimateController.selectedEstimate.client.siret,
                                                                   tva: estimateController.selectedEstimate.client.tva,
                                                                   address: estimateController.selectedEstimate.client.address),
                                       products: estimateController.selectedEstimate.products)
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
