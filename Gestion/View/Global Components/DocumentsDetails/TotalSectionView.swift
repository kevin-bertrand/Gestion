//
//  TotalSectionView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 08/09/2022.
//

import SwiftUI

struct TotalSectionView: View {
    let totalService: Double
    let totalMaterials: Double
    let totalDivers: Double
    let total: Double
    
    var body: some View {
        Section {
            Text("Total services: \(totalService.twoDigitPrecision) €")
            Text("Total material: \(totalMaterials.twoDigitPrecision) €")
            Text("Total Divers: \(totalDivers.twoDigitPrecision) €")
            Text("Total: \(total.twoDigitPrecision) €")
                .font(.title2.bold())
        } header: {
            Text("Total")
        }
    }
}

struct TotalSectionView_Previews: PreviewProvider {
    static var previews: some View {
        TotalSectionView(totalService: 0, totalMaterials: 0, totalDivers: 0, total: 0)
    }
}
