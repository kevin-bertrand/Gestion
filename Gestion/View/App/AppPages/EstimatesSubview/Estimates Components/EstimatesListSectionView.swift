//
//  EstimatesListSectionView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 08/09/2022.
//

import SwiftUI

struct EstimatesListSectionView: View {
    let list: [Estimate.Summary]
    let status: EstimateStatus
    let title: String
    
    var body: some View {
        Section {
            ForEach(list, id: \.reference) { estimate in
                if estimate.status == status {
                    EstimateListTileView(estimate: estimate)
                }
            }
        } header: {
            Text(title)
        }
    }
}

struct EstimatesListSectionView_Previews: PreviewProvider {
    static var previews: some View {
        EstimatesListSectionView(list: [], status: .inCreation, title: "")
    }
}
