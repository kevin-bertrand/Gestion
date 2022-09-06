//
//  EstimatesView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 30/08/2022.
//

import SwiftUI

struct EstimatesView: View {
    @EnvironmentObject var estimatesController: EstimatesController
    @EnvironmentObject var userController: UserController
    
    @State private var estimateList: [String] = ["Estimate 1", "Estimate 2"]
    @State private var searchingText: String = ""
    
    var body: some View {
        List {
            Section {
                ForEach(estimatesController.estimatesList, id: \.reference) { estimate in
                    if estimate.status == .late {
                        EstimateListTileView(estimate: estimate)
                    }
                }
            } header: {
                Text("Late estimates")
            }
            
            Section {
                ForEach(estimatesController.estimatesList, id: \.reference) { estimate in
                    if estimate.status == .inCreation {
                        EstimateListTileView(estimate: estimate)
                    }
                }
            } header: {
                Text("In creation estimate")
            }

            Section {
                ForEach(estimatesController.estimatesList, id: \.reference) { estimate in
                    if estimate.status == .sent {
                        EstimateListTileView(estimate: estimate)
                    }
                }
            } header: {
                Text("Sent estimates")
            }
            
            Section {
                ForEach(estimatesController.estimatesList, id: \.reference) { estimate in
                    if estimate.status == .refused {
                        EstimateListTileView(estimate: estimate)
                    }
                }
            } header: {
                Text("Refused estimates")
            }
            
            Section {
                ForEach(estimatesController.estimatesList, id: \.reference) { estimate in
                    if estimate.status == .accepted {
                        EstimateListTileView(estimate: estimate)
                    }
                }
            } header: {
                Text("Accepted estimate")
            }
            
        }
        .navigationTitle("Estimates")
        .searchable(text: $searchingText)
        .refreshable {
            estimatesController.downloadAllEstimatesSummary(for: userController.connectedUser)
        }
        .toolbar {
            NavigationLink {
                AddEstimateView()
            } label: {
                Image(systemName: "plus.circle")
            }
        }
        .onAppear {
            estimatesController.downloadAllEstimatesSummary(for: userController.connectedUser)
        }
    }
}

struct EstimatesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EstimatesView()
                .environmentObject(EstimatesController(appController: AppController()))
                .environmentObject(UserController(appController: AppController()))
        }
    }
}
