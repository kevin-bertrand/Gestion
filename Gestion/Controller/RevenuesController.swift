//
//  RevenuesController.swift
//  Gestion
//
//  Created by Kevin Bertrand on 01/09/2022.
//

import Foundation

final class RevenuesController: ObservableObject {
    // MARK: Public
    // MARK: Properties
    // General properties
    var appController: AppController
    
    // Home View
    @Published var yearRevenues: Double = 0.0
    @Published var monthRevenues: Double = 0.0
    @Published var thisMonthRevenue: Revenues.Month = .init(id: UUID(uuid: UUID_NULL), totalDivers: 0.0, totalServices: 0.0, totalMaterials: 0.0, grandTotal: 0.0, month: 0, year: 0)
    @Published var thisYearRevenues: [Revenues.Month] = []
    
    // MARK: Methods
    /// Downlaod revenue summary
    func downloadRevenues(for user: User?) {
        guard let user = user else { return }
        
        revenuesManager.getThisYear(for: user)
    }
    
    /// Download this month revenues
//    func downloadThisMonth(for user: User?) {
//        guard let user = user else { return }
//        
//        revenuesManager.gettingThisMonthRevenues(for: user)
//    }
    
    func downloadMonthRevenues(for month: Int, and year: Int, by user: User?) {
        guard let user = user else { return }
        
        revenuesManager.gettingThisMonthRevenues(forMonth: month, andYear: year, by: user)
    }
    
    /// Download all month for this year
    func downloadAllMonths(for user: User?) {
        guard let user = user else { return }
        
        revenuesManager.getAllMonthThisYear(for: user)
    }
    
    // MARK: Initialization
    init(appController: AppController) {
        self.appController = appController
        
        // Configure home notifications
        configureNotification(for: Notification.Desyntic.revenuesSuccess.notificationName)
        configureNotification(for: Notification.Desyntic.revenueThisMonth.notificationName)
        configureNotification(for: Notification.Desyntic.revenueAllMonths.notificationName)
    }
    
    // MARK: Private
    // MARK: Properties
    private let revenuesManager = RevenuesManager()
    
    // MARK: Methods
    /// Configure notification
    private func configureNotification(for name: Notification.Name) {
        NotificationCenter.default.addObserver(self, selector: #selector(processNotification), name: name, object: nil)
    }
    
    /// Initialise all notification for this controller
    @objc private func processNotification(_ notification: Notification) {
        if let notificationName = notification.userInfo?["name"] as? Notification.Name,
           let _ = notification.userInfo?["message"] as? String {
            DispatchQueue.main.async {
                self.appController.resetLoadingInProgress()
                
                switch notificationName {
                case Notification.Desyntic.revenuesSuccess.notificationName:
                    self.yearRevenues = self.revenuesManager.thisYearRevenue
//                    self.monthRevenues = self.revenuesManager.thisMonthRevenue
                case Notification.Desyntic.revenueThisMonth.notificationName:
                    self.thisMonthRevenue = self.revenuesManager.thisMonthRevenue
                case Notification.Desyntic.revenueAllMonths.notificationName:
                    self.thisYearRevenues = self.revenuesManager.allMonthsThisYear
                default: break
                }
            }
        }
    }
}
