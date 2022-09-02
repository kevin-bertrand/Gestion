//
//  CircularChart.swift
//  Gestion
//
//  Created by Kevin Bertrand on 02/09/2022.
//

import SwiftUI

struct CircularChart: View {
    @Environment(\.colorScheme) var colorScheme
    
    let totalServices: Double
    let totalMaterials: Double
    let totalDivers: Double
    
    var body: some View {
        PieChartView(values: [totalMaterials,
                              totalServices,
                              totalDivers],
                     names: ["Materials", "Services", "Divers"],
                     formatter: { number in
            return "\(number)"
        }, colorScheme: colorScheme)
        .padding()
    }
}

struct CircularChart_Previews: PreviewProvider {
    static var previews: some View {
        CircularChart(totalServices: 0, totalMaterials: 0, totalDivers: 0)
    }
}
