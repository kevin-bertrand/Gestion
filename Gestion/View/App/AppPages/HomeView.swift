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
    @EnvironmentObject var userController: UserController
    @EnvironmentObject var revenuesController: RevenuesController
    
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
                    
                    InfoTile(title: "This month", value: "\(revenuesController.thisMonthRevenue.grandTotal.twoDigitPrecision) €")
                    
                    Spacer()
                    Divider()
                        .padding(.vertical)
                    Spacer()
                    
                    InfoTile(title: "This year", value: "\(revenuesController.yearRevenues.twoDigitPrecision) €")

                    Spacer()
                })
            }
            .frame(height: 125)
            
            VStack {
                SectionTitleCustom(title: "This month revenue")
                
                RoundedRectangleCustom {
                    AnyView(VStack {
                        Spacer()
                        PieChartView(values: [revenuesController.thisMonthRevenue.totalMaterials, revenuesController.thisMonthRevenue.totalServices, revenuesController.thisMonthRevenue.totalDivers],
                                     names: ["Materials", "Services", "Divers"],
                                     formatter: { number in
                            return "\(number)"
                        }, colorScheme: colorScheme)
                        .padding()
                        Spacer()
                    })
                }.frame(height: 475)
            }
            
            VStack {
                SectionTitleCustom(title: "This year profits")

                RoundedRectangleCustom {
                    AnyView(VStack {
                        Text("Total revenues of this year: \(revenuesController.yearRevenues.twoDigitPrecision)€")
                            .font(.title2)
                            .foregroundColor(.accentColor)
                        
                        Chart(revenuesController.thisYearRevenues) {
                            LineMark(
                                x: .value("Mount", "\($0.month)/\($0.year)"),
                                y: .value("Value", $0.grandTotal)
                            )
                            PointMark(
                                x: .value("Mount", "\($0.month)/\($0.year)"),
                                y: .value("Value", $0.grandTotal)
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
        .onAppear {
            revenuesController.downloadRevenues(for: userController.connectedUser)
            revenuesController.downloadThisMonth(for: userController.connectedUser)
            revenuesController.downloadAllMonths(for: userController.connectedUser)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView(selectedTab: .constant(1))
                .environmentObject(UserController(appController: AppController()))
                .environmentObject(RevenuesController(appController: AppController()))
        }
    }
}
