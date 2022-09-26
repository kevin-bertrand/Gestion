//
//  EstimateListTileView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 02/09/2022.
//

import SwiftUI

struct EstimateListTileView: View {
    let estimate: Estimate.Summary
    
    var body: some View {
        NavigationLink {
            EstimateDetail(selectedEstimate: estimate.id)
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                Text(estimate.reference)
                Text("\(estimate.total.twoDigitPrecision) €")
                    .foregroundColor(.gray)
                    .font(.callout)
                Text(estimate.limitValidifyDate.formatted(date: .numeric, time: .omitted))
                    .foregroundColor(.gray)
                    .font(.callout)
            }
        }
    }
}

struct EstimateListTileView_Previews: PreviewProvider {
    static var previews: some View {
        EstimateListTileView(estimate: Estimate.Summary(id: nil, client: Client.Summary(firstname: "", lastname: "", company: ""), reference: "", total: 0, status: .inCreation, limitValidifyDate: Date(), isArchive: true))
    }
}
