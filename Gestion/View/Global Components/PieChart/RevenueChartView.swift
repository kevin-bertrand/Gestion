//
//  RevenueChartView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 08/09/2022.
//

import SwiftUI

struct RevenueChartView: View {
    @Environment(\.colorScheme) var colorScheme
    
    let totalMaterials: Double
    let totalServices: Double
    let totalDivers: Double
    
    var body: some View {
        PieChartView(values: [totalMaterials, totalServices, totalDivers],
                     names: ["Materials", "Services", "Divers"],
                     formatter: { number in
            return "\(number)"
        }, colorScheme: colorScheme)
        .frame(height: 420)
    }
}

struct RevenueChartView_Previews: PreviewProvider {
    static var previews: some View {
        RevenueChartView(totalMaterials: 0, totalServices: 0, totalDivers: 0)
    }
}
