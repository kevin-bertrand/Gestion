//
//  HomeView.swift
//  Gestion-Mac
//
//  Created by Kevin Bertrand on 27/10/2022.
//

import SwiftUI

struct HomeView: View {
    let totalMaterials = 150.0
    let totalServices = 200.0
    let totalDivers = 170.0
    
    @State private var pieView: CGSize = .zero
    @State private var selectedMonth: Int = 1
    @State private var selectedYear: Int = 20
    var yearRange: Range<Int> = 19..<Calendar.current.component(.year, from: Date())-2000+1
    
    var body: some View {
        HStack {
            ScrollView {
                HStack {
                    Text("Month revenues")
                        .font(.title.bold())
                    Spacer()
                    Picker("", selection: $selectedMonth) {
                        ForEach(1..<13) { month in
                            Text("\(month)")
                                .tag(month)
                        }
                    }.frame(width: 100)
                    Text("/")
                    Picker("", selection: $selectedYear) {
                        ForEach(yearRange) { year in
                            Text("20\(year)")
                                .tag(year)
                        }
                    }.frame(width: 100)
                }
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.white)
                    .overlay {
                        PieChartView(values: [totalMaterials, totalServices, totalDivers],
                                     names: ["Materials", "Services", "Divers"],
                                     formatter: { number in
                            return "\(number)"
                        }, colorScheme: .light, size: { size in
                            print(size)
                            pieView = size
                        })
                        .padding()
                        .frame(width: 600, height: 600)
                    }.frame(width: 650, height: 650)
            }.padding()
            
            Spacer()
            
            VStack {
                Text("dshbxigsyqdfhvaukdjzhqfisdkjflbnljksbdfkhjsdbfukyhjbk")
            }.padding()
        }
        .navigationTitle("Home")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
