//
//  RevenuesManager.swift
//  Gestion
//
//  Created by Kevin Bertrand on 01/09/2022.
//

import Foundation

final class RevenuesManager {
    // MARK: Public
    // MARK: Properties
    var thisYearRevenue: Double = 0.0
    var thisMonthRevenue: Revenues.Month = .init(id: UUID(uuid: UUID_NULL), totalDivers: 0, totalServices: 0, totalMaterials: 0, grandTotal: 0, month: 0, year: 0)
    var allMonthsThisYear: [Revenues.Month] = []
    
    // MARK: Methods
    /// Download this year revenue
    func getThisYear(for user: User) {
        let components = Calendar.current.dateComponents([.year, .month], from: Date())
        guard let year = components.year else { return }
        var params = NetworkConfigurations.revenueGetYear.urlParams
        params.append("\(year)")
        
        networkManager.request(urlParams: params, method: NetworkConfigurations.revenueGetYear.method, authorization: .authorization(bearerToken: user.token), body: nil) { [weak self] data, response, error in
            if let self = self,
               let statusCode = response?.statusCode,
               let data = data,
               statusCode == 200,
               let revenues = try? JSONDecoder().decode(Revenues.Year.self, from: data) {
                self.thisYearRevenue = revenues.grandTotal
                Notification.Desyntic.revenuesSuccess.sendNotification()
            } else {
                Notification.Desyntic.unknownError.sendNotification()
            }
        }
    }
    
    /// Download this month revenues
    func gettingThisMonthRevenues(for user: User) {
        let components = Calendar.current.dateComponents([.year, .month], from: Date())
        guard let year = components.year, let month = components.month else { return }
        var params = NetworkConfigurations.revenueGetMonth.urlParams
        params.append("\(month)")
        params.append("\(year)")
        
        networkManager.request(urlParams: params,
                               method: NetworkConfigurations.revenueGetMonth.method,
                               authorization: .authorization(bearerToken: user.token), body: nil) { [weak self] data, response, error in
            if let self = self,
               let statusCode = response?.statusCode,
               let data = data,
               statusCode == 200,
               let revenues = try? JSONDecoder().decode(Revenues.Month.self, from: data) {
                self.thisMonthRevenue = revenues
                Notification.Desyntic.revenueThisMonth.sendNotification()
            } else {
                Notification.Desyntic.unknownError.sendNotification()
            }
        }
    }
    
    /// Download this year all month
    func getAllMonthThisYear(for user: User) {
        networkManager.request(urlParams: NetworkConfigurations.revenueAllMonths.urlParams, method: NetworkConfigurations.revenueAllMonths.method, authorization: .authorization(bearerToken: user.token), body: nil) { [weak self] data, response, error in
            if let self = self,
               let statusCode = response?.statusCode,
               let data = data,
               statusCode == 200,
               let revenues = try? JSONDecoder().decode([Revenues.Month].self, from: data) {
                self.allMonthsThisYear = revenues
                Notification.Desyntic.revenueAllMonths.sendNotification()
            } else {
                Notification.Desyntic.unknownError.sendNotification()
            }
        }
    }
    
    // MARK: Initialization
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    // MARK: Private
    // MARK: Properties
    private let networkManager: NetworkManager
}
