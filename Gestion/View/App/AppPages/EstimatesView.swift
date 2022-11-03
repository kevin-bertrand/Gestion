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
            EstimatesListSectionView(list: estimatesController.estimatesList, status: .late, title: "Late estimates")
            EstimatesListSectionView(list: estimatesController.estimatesList, status: .inCreation, title: "In creation estimate")
            EstimatesListSectionView(list: estimatesController.estimatesList, status: .sent, title: "Sent estimates")
            EstimatesListSectionView(list: estimatesController.estimatesList, status: .refused, title: "Refused estimates")
            EstimatesListSectionView(list: estimatesController.estimatesList, status: .accepted, title: "Accepted estimate")
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
        .task {
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
