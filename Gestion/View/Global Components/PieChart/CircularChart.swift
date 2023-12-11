//
//  CircularChart.swift
//  Gestion
//
//  Created by Kevin Bertrand on 02/09/2022.
//

import SwiftUI

struct CircularChart: View {
    // MARK: Environment
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: Properties
    let totalServices: Double
    let totalMaterials: Double
    let totalDivers: Double
    var backgroundColor: Color = .black
    
    // MARK: States
    @State private var chartHeight: CGFloat = 0.0
    
    // MARK: Body
    var body: some View {
        PieChartView(values: [totalMaterials,
                              totalServices,
                              totalDivers],
                     names: ["Materials", "Services", "Divers"],
                     formatter: { number in
            "\(number)"
        }, 
                     colorScheme: colorScheme,
                     backgroundColor: backgroundColor,
                     size: { size in
            chartHeight = size.width
        })
        .padding()
        .frame(height: chartHeight)
    }
}

#Preview {
    CircularChart(totalServices: 0, totalMaterials: 0, totalDivers: 0)
}
