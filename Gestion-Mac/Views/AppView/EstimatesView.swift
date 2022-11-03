//
//  EstimatesView.swift
//  Gestion-Mac
//
//  Created by Kevin Bertrand on 27/10/2022.
//

import SwiftUI

struct EstimatesView: View {
    let table: [Estimate.Summary] = [.init(id: UUID(), client: Client.Summary.init(firstname: "", lastname: "", company: ""), reference: "Testing", total: 0.0, status: .accepted, limitValidifyDate: Date(), isArchive: true)]
    
    var body: some View {
        NavigationView {
            List {
                EstimatesListSectionView(list: table, status: .late, title: "Late estimates")
                EstimatesListSectionView(list: table, status: .inCreation, title: "In creation estimate")
                EstimatesListSectionView(list: table, status: .sent, title: "Sent estimates")
                EstimatesListSectionView(list: table, status: .refused, title: "Refused estimates")
                EstimatesListSectionView(list: table, status: .accepted, title: "Accepted estimate")
//                ForEach(1..<5) { estimate in
//                    NavigationLink {
//                        Text("\(estimate)")
//                    } label: {
//                        Text("Estimate \(estimate)")
//                    }
//                }
            }
        }
    }
}

struct EstimatesView_Previews: PreviewProvider {
    static var previews: some View {
        EstimatesView()
    }
}
