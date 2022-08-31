//
//  EstimatesView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 30/08/2022.
//

import SwiftUI

struct EstimatesView: View {
    @State private var estimateList: [String] = ["Estimate 1", "Estimate 2"]
    @State private var searchingText: String = ""
    
    var body: some View {
        List {
            ForEach(estimateList, id: \.self) { estimate in
                NavigationLink {
                    Text(estimate)
                } label: {
                    Text(estimate)
                }
            }
        }
        .searchable(text: $searchingText)
        .refreshable {
            // TODO: Refresh list
        }
    }
}

struct EstimatesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EstimatesView()
        }
    }
}
