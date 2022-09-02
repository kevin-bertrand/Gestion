//
//  InvoicesController.swift
//  Gestion
//
//  Created by Kevin Bertrand on 01/09/2022.
//

import Foundation
import PDFKit
import SwiftUI

final class InvoicesController: ObservableObject {
    // MARK: Public
    // MARK: Properties
    // General properties
    var appController: AppController
    
    // Home page
    @Published var invoicesSummary: [Invoice.Summary] = []
    
    // Detail page
    @Published var selectedInvoice: Invoice.Informations
    
    // Invoices list
    @Published var invoicesList: [Invoice.Summary] = []
    
    // MARK: Methods
    /// Download invoices for home page
    func downloadInvoicesSummary(for user: User?) {
        guard let user = user else { return }
        
        invoicesManager.downloadThreeLatests(for: user)
    }
    
    /// Download all invoices summary
    func downloadAllInvoicesSummary(for user: User?) {
        guard let user = user else { return }
        
        invoicesManager.downloadAllInvoiceSummary(for: user)
    }
    
    /// Select invoice
    func selectInvoice(id: UUID?, by user: User?) {
        guard let user = user, let id = id else { return }
        
        appController.setLoadingInProgress(withMessage: "Downloading in progress... Please wait!")
        
        invoicesManager.downloadInvoiceDetails(id: id, for: user)
    }
    
    /// Unselect invoice
    func unselectInvoice() {
        selectedInvoice = InvoicesManager.emptyInvoiceDetail
    }
    
    /// Export to PDF
    func exportToPDF() {
        var isSuccess: Bool = false
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let outputFileURL = documentDirectory.appendingPathComponent("\(selectedInvoice.reference).pdf")
        
        //Normal width
        let width: CGFloat = 8.5 * 72.0
        //Estimate the height of your view
        let height: CGFloat = 1000
        let invoice = InvoicePDF(invoice: selectedInvoice)
        
        let pdfVC = UIHostingController(rootView: invoice)
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
        selectedInvoice = InvoicesManager.emptyInvoiceDetail
        
        // Configure home notifications
        configureNotification(for: Notification.Desyntic.invoicesSummarySuccess.notificationName)
        
        // Configure details notification
        configureNotification(for: Notification.Desyntic.invoicesGettingOne.notificationName)
        
        // Confifure invoice list notificaitons
        configureNotification(for: Notification.Desyntic.invoicesListDownloaded.notificationName)
    }
    
    // MARK: Private
    // MARK: Properties
    private let invoicesManager = InvoicesManager()
    
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
                case Notification.Desyntic.invoicesSummarySuccess.notificationName:
                    self.invoicesSummary = self.invoicesManager.invoicesSummary
                case Notification.Desyntic.invoicesGettingOne.notificationName:
                    self.selectedInvoice = self.invoicesManager.invoiceDetail
                case Notification.Desyntic.invoicesListDownloaded.notificationName:
                    self.invoicesList = self.invoicesManager.invoicesList
                default: break
                }
            }
        }
    }
}
