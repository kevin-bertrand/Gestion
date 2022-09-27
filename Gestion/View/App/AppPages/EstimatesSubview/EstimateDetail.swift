//
//  EstimateDetail.swift
//  Gestion
//
//  Created by Kevin Bertrand on 02/09/2022.
//

import SwiftUI

struct EstimateDetail: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var estimateController: EstimatesController
    @EnvironmentObject var userController: UserController
    
    let selectedEstimate: UUID?
    
    var body: some View {
        List {
            ClientDetailsView(selectedClient: .constant(estimateController.selectedEstimate.client))
            
            Section {
                Label("Internal ref: \(estimateController.selectedEstimate.internalReference)", systemImage: "doc.text")
                Label("Object: \(estimateController.selectedEstimate.object)", systemImage: "doc.text")
                Label("Sending date: \(estimateController.selectedEstimate.sendingDate.formatted(date: .numeric, time: .omitted))", systemImage: "hourglass")
                Label("Limit: \(estimateController.selectedEstimate.limitValidityDate.formatted(date: .numeric, time: .omitted))", systemImage: "hourglass")
                Label("Status \(estimateController.selectedEstimate.status.rawValue)", systemImage: "list.triangle")
            } header: {
                Text("Invoice details")
            }
            
            Section {
                RevenueChartView(totalMaterials: estimateController.selectedEstimate.totalMaterials, totalServices: estimateController.selectedEstimate.totalServices, totalDivers: estimateController.selectedEstimate.totalDivers)
            } header: {
                Text("Incomes")
            }
            
            Section {
                if estimateController.selectedEstimate.status != .accepted || estimateController.selectedEstimate.status != .refused {
                    NavigationLink("Update") {
                        UpdateEstimateView(estimate: estimateController.selectedEstimate.toUpdate(),
                                           client: estimateController.selectedEstimate.client,
                                           products: estimateController.selectedEstimate.products)
                    }
                }
                
                NavigationLink("Show PDF") {
                    PDFUIView(pdf: estimateController.estimatePdf)
                }
                
                Button {
                    estimateController.exportToInvoice(by: userController.connectedUser)
                } label: {
                    Text("Export as an invoice")
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
                dismiss()
            }
        }
        .onChange(of: estimateController.estimateIsExportedToInvoice) { newValue in
            if newValue {
                estimateController.estimateIsExportedToInvoice = false
                dismiss()
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
