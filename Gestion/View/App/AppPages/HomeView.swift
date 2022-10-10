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
    @State private var selectedMonth: Int = 1
    @State private var selectedYear: Int = 20
    var yearRange: Range<Int> = 19..<Calendar.current.component(.year, from: Date())-2000+1
    
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
                HStack {
                    SectionTitleCustom(title: "Month revenue")
                    
                    Spacer()
                    
                    Picker("", selection: $selectedMonth) {
                        ForEach(1..<13) { month in
                            Text("\(month)")
                                .tag(month)
                        }
                    }
                    Text("/")
                    Picker("", selection: $selectedYear) {
                        ForEach(yearRange) { year in
                            Text("20\(year)")
                                .tag(year)
                        }
                    }
                }
                
                RoundedRectangleCustom {
                    AnyView(VStack {
                        RevenueChartView(totalMaterials: revenuesController.thisMonthRevenue.totalMaterials, totalServices: revenuesController.thisMonthRevenue.totalServices, totalDivers: revenuesController.thisMonthRevenue.totalDivers)
                            .padding()
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
                                EstimateDetail(selectedEstimate: estimate.id)
                            } label: {
                                TileView(icon: "pencil.and.ruler.fill",
                                         title: estimate.reference,
                                         value: "\(estimate.total.twoDigitPrecision) €", limit: "Limit: \(estimate.limitValidifyDate.formatted(date: .numeric, time: .omitted))",
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
                            InvoiceTileView(invoice: invoice)
                        }
                    }
                }
            }
        }
        .navigationTitle(Text("Welcome"))
        .padding(.horizontal)
        .onAppear {
            revenuesController.downloadRevenues(for: userController.connectedUser)
            revenuesController.downloadAllMonths(for: userController.connectedUser)
            estimatesController.downloadEstimatesSummary(for: userController.connectedUser)
            invoicesController.downloadInvoicesSummary(for: userController.connectedUser)
            selectedMonth = Calendar.current.component(.month, from: Date())
            selectedYear = Calendar.current.component(.year, from: Date())-2000
        }
        .onChange(of: selectedMonth) { newValue in
            revenuesController.downloadMonthRevenues(for: selectedMonth, and: 2000+selectedYear, by: userController.connectedUser)
        }
        .onChange(of: selectedYear) { newValue in
            revenuesController.downloadMonthRevenues(for: selectedMonth, and: 2000+selectedYear, by: userController.connectedUser)
        }
    }
    
    private func getEstimateColor(status: EstimateStatus) -> Color {
        switch status {
        case .inCreation:
            return .accentColor
        case .sent:
            return .purple
        case .refused:
            return .gray
        case .late:
            return .red
        case .accepted:
            return .green
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
                .environmentObject(InvoicesController(appController: AppController()))
        }
    }
}
