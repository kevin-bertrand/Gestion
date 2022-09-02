//
//  EstimatesController.swift
//  Gestion
//
//  Created by Kevin Bertrand on 01/09/2022.
//

import Foundation
import PDFKit
import SwiftUI

final class EstimatesController: ObservableObject {
    // MARK: Public
    // MARK: Properties
    // General properties
    var appController: AppController
    
    // Home page
    @Published var estimatesSummary: [Estimate.Summary] = []
    
    // Estimate list
    @Published var estimatesList: [Estimate.Summary] = []
    
    // Detail page
    @Published var selectedEstimate: Estimate.Informations = EstimatesManager.emptyDetail
    
    // MARK: Methods
    /// Download estimates for home page
    func downloadEstimatesSummary(for user: User?) {
        guard let user = user else { return }
        
        estimatesManager.downloadThreeLatests(for: user)
    }
    
    /// Download all estimates
    func downloadAllEstimatesSummary(for user: User?) {
        guard let user = user else { return }
        
        estimatesManager.downloadAllEstimates(for: user)
    }
    
    /// Download estimate detail
    func downloadEstimateDetail(id: UUID?, by user: User?) {
        guard let user = user, let id = id else { return }
        
        appController.setLoadingInProgress(withMessage: "Downloading in progress... Please wait!")
        
        estimatesManager.downloadEstimateDetails(id: id, for: user)
    }
    
    /// Export to PDF
    func exportToPDF() {
        var isSuccess: Bool = false
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let outputFileURL = documentDirectory.appendingPathComponent("\(selectedEstimate.reference).pdf")
        
        //Normal width
        let width: CGFloat = 8.5 * 72.0
        //Estimate the height of your view
        let height: CGFloat = 1000
        let estimate = EstimatePDF(estimate: selectedEstimate)
        
        let pdfVC = UIHostingController(rootView: estimate)
        pdfVC.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        //Render the view behind all other views
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let rootVC = windowScenes?.windows.first?.rootViewController
        rootVC?.addChild(pdfVC)
        rootVC?.view.insertSubview(pdfVC.view, at: 0)
        
        //Render the PDF
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 8.5 * 72.0, height: height))
        
        do {
            try pdfRenderer.writePDF(to: outputFileURL, withActions: { (context) in
                context.beginPage()
                pdfVC.view.layer.render(in: context.cgContext)
            })
            isSuccess = true
        }catch {
            print("Could not create PDF file: \(error)")
        }
        pdfVC.removeFromParent()
        pdfVC.view.removeFromSuperview()
        
        if isSuccess {
            appController.showAlertView(withMessage: "The PDF is exported! Find it in your Files App", andTitle: "Success")
        } else {
            appController.showAlertView(withMessage: "The PDF could not be export!", andTitle: "Error")
        }
    }
    
    
    // MARK: Initialization
    init(appController: AppController) {
        self.appController = appController
        
        // Configure home notifications
        configureNotification(for: Notification.Desyntic.estimatesSummarySuccess.notificationName)
        
        // Configure list notification
        configureNotification(for: Notification.Desyntic.estimatesListDownload.notificationName)
        
        // Configure estimate details notifications
        configureNotification(for: Notification.Desyntic.estimateGettingOne.notificationName)
    }
    
    // MARK: Private
    // MARK: Properties
    private let estimatesManager = EstimatesManager()
    
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
                case Notification.Desyntic.estimatesSummarySuccess.notificationName:
                    self.estimatesSummary = self.estimatesManager.estimatesSummary
                case Notification.Desyntic.estimatesListDownload.notificationName:
                    self.estimatesList = self.estimatesManager.estimatesList
                case Notification.Desyntic.estimateGettingOne.notificationName:
                    self.selectedEstimate = self.estimatesManager.estimateDetail
                default: break
                }
            }
        }
    }
}
