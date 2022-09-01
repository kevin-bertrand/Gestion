//
//  HomeView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 30/08/2022.
//

import Charts
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userController: UserController
    @EnvironmentObject var revenuesController: RevenuesController
    @EnvironmentObject var estimatesController: EstimatesController
    @EnvironmentObject var invoicesController: InvoicesController
    
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedTab: Int
        
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
                        ForEach(estimatesController.estimatesSummary, id: \.reference) { estimate in
                            NavigationLink {
                                Text("Estimate")
                            } label: {
                                TileView(icon: "pencil.and.ruler.fill",
                                         title: estimate.reference,
                                         value: "\(estimate.grandTotal.twoDigitPrecision) €", limit: "Limit: \(estimate.limitValidifyDate.formatted(date: .numeric, time: .omitted))",
                                         iconColor: getEstimateColor(status: estimate.status))
                            }
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
                        ForEach(invoicesController.invoicesSummary, id:\.reference) { invoice in
                            NavigationLink {
                                InvoiceDetail()
                            } label: {
                                TileView(icon: "eurosign",
                                         title: "\(invoice.reference)",
                                         value: "\(invoice.grandTotal.twoDigitPrecision) €",
                                         limit: "Limit: \(invoice.limitPayementDate.formatted(date: .numeric, time: .omitted))",
                                         iconColor: getInvoiceColor(status: invoice.status))
                            }
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
            estimatesController.downloadEstimatesSummary(for: userController.connectedUser)
            invoicesController.downloadInvoicesSummary(for: userController.connectedUser)
        }
    }
    
    private func getEstimateColor(status: EstimateStatus) -> Color {
        switch status {
        case .inCreation:
            return .accentColor
        case .sent:
            return .green
        case .refused:
            return .gray
        case .late:
            return .red
        }
    }
    
    private func getInvoiceColor(status: InvoiceStatus) -> Color {
        switch status {
        case .inCreation:
            return .accentColor
        case .sent:
            return .gray
        case .payed:
            return .green
        case .overdue:
            return .red
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView(selectedTab: .constant(1))
                .environmentObject(UserController(appController: AppController()))
                .environmentObject(RevenuesController(appController: AppController()))
                .environmentObject(EstimatesController(appController: AppController()))
        }
    }
}
