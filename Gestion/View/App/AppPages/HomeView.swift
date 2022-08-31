//
//  HomeView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 30/08/2022.
//

import Charts
import SwiftUI

struct MountPrice: Identifiable {
    var id = UUID()
    var mount: String
    var value: Double
}

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedTab: Int
    
    let data: [MountPrice] = [
        MountPrice(mount: "jan/22", value: 5),
        MountPrice(mount: "feb/22", value: 4),
        MountPrice(mount: "mar/22", value: 7),
        MountPrice(mount: "apr/22", value: 15),
        MountPrice(mount: "may/22", value: 14),
        MountPrice(mount: "jun/22", value: 27),
        MountPrice(mount: "jul/22", value: 27)
    ]
    
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            RoundedRectangleCustom {
                AnyView(HStack {
                    Spacer()
                    
                    InfoTile(title: "This month", value: "250 €")
                    
                    Spacer()
                    Divider()
                    Spacer()
                    
                    InfoTile(title: "This year", value: "250 €")

                    Spacer()
                })
            }
            .frame(height: 125)
            
            VStack {
                SectionTitleCustom(title: "This month revenue")
                
                RoundedRectangleCustom {
                    AnyView(VStack {
                        Spacer()
                        PieChartView(values: [1, 20], names: ["Materials", "Services"], formatter: { number in
                            return "\(number)"
                        }, colorScheme: colorScheme)
                        .padding()
                        Spacer()
                    })
                }.frame(height: 420)
            }
            
            VStack {
                SectionTitleCustom(title: "This year profits")

                RoundedRectangleCustom {
                    AnyView(VStack {
                        Text("Total revenues of this year: 250€")
                            .font(.title2)
                            .foregroundColor(.accentColor)
                        
                        Chart(data) {
                            LineMark(
                                x: .value("Mount", $0.mount),
                                y: .value("Value", $0.value)
                            )
                            PointMark(
                                x: .value("Mount", $0.mount),
                                y: .value("Value", $0.value)
                            )
                        }
                        .frame(height: 300)
                        .padding()
                    })
                }.frame(height: 420)
            }
            
            VStack {
                SectionTitleCustom(title: "Estimates", hasButton: true) {
                    selectedTab = 2
                }
                
                ScrollView(.horizontal) {
                    HStack {
                        NavigationLink {
                            Text("Estimate")
                        } label: {
                            TileView(icon: "pencil.and.ruler.fill", title: "D-2022-01", value: "240€", limit: "Limit: 15/09/2022")
                        }
                    }
                }
            }
            
            VStack {
                SectionTitleCustom(title: "Invoices", hasButton: true) {
                    selectedTab = 3
                }
                                
                ScrollView(.horizontal) {
                    HStack {
                        NavigationLink {
                            InvoiceDetail()
                        } label: {
                            TileView(icon: "eurosign", title: "F-2022-01", value: "240€", limit: "Limit: 01/10/2022")
                        }
                    }
                }
            }
        }
        .navigationTitle(Text("Welcome"))
        .padding(.horizontal)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView(selectedTab: .constant(1))
        }
    }
}
