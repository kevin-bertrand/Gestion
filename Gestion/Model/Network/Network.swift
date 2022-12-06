//
//  Network.swift
//  Gestion
//
//  Created by Kevin Bertrand on 31/08/2022.
//

import Alamofire
import Foundation

enum NetworkConfigurations {
    // MARK: Clients
    case clientAdd
    case clientUpdate
    case clientGetList
    
    // MARK: Widget
    case widgetGetData
    
    // MARK: Internal Reference
    case internalReference
    
    // MARK: Estimates
    case estimateGetReference
    case estimateGetList
    case estimateGetDetails
    case estimateAdd
    case estimateUpdate
    case estimateExportToInvoice
    case estimatePDF
    
    // MARK: Invoices
    case invoiceGetOne
    case invoiceGetReference
    case invoiceAdd
    case invoiceUpdate
    case invoiceGetList
    case invoicePDF
    case invoicePaied
    
    // MARK: Payment
    case paymentAdd
    case paymentUpdate
    case paymentDelete
    case paymentGetList
    
    // MARK: Products
    case productAdd
    case productUpdate
    case productGetList
    case productGetCategories
    case productGetDomains
    
    // MARK: Revenues
    case revenueGetYear
    case revenueGetMonth
    case revenueAllMonths
    
    // MARK: Staff
    case staffLogin
    case staffAdd
    case staffUpdate
    case staffUpdatePassword
    case staffUpdateProfilePicture
    case staffDelete
    case staffGetList
    case staffGetOne
    case staffProfilePicture
    
    var method: HTTPMethod {
        var method: HTTPMethod
        
        switch self {
        case .clientAdd,
                .estimateAdd, .estimateExportToInvoice,
                .invoiceAdd,
                .paymentAdd,
                .productAdd,
                .staffLogin, .staffAdd:
            method = .post
        case .clientUpdate,
                .estimateUpdate,
                .invoiceUpdate, .invoicePaied,
                .paymentUpdate,
                .productUpdate,
                .staffUpdate, .staffUpdatePassword, .staffUpdateProfilePicture:
            method = .patch
        case .clientGetList,
                .internalReference,
                .estimateGetReference, .estimateGetList, .estimateGetDetails, .estimatePDF,
                .invoiceGetOne, .invoiceGetReference, .invoiceGetList, .invoicePDF,
                .productGetList, .productGetCategories, .productGetDomains,
                .paymentGetList,
                .revenueGetYear, .revenueGetMonth, .revenueAllMonths,
                .staffGetList, .staffGetOne, .staffProfilePicture,
                .widgetGetData:
            method = .get
        case .paymentDelete,
                .staffDelete:
            method = .delete
        }
        
        return method
    }
    
    var urlParams: [String] {
        var params: [String]
        
        switch self {
        case .widgetGetData:
            params = ["widget"]
        case .clientUpdate, .clientGetList, .clientAdd:
            params = ["client"]
        case .internalReference:
            params = ["internalRef"]
        case .estimateGetDetails, .estimateUpdate, .estimateAdd:
            params = ["estimate"]
        case .estimatePDF:
            params = ["estimate", "pdf"]
        case .estimateGetReference:
            params = ["estimate", "reference"]
        case .estimateGetList:
            params = ["estimate", "list"]
        case .estimateExportToInvoice:
            params = ["estimate", "toInvoice"]
        case .invoiceAdd, .invoiceUpdate, .invoiceGetList, .invoiceGetOne:
            params = ["invoice"]
        case .invoicePaied:
            params = ["invoice", "paied"]
        case .invoiceGetReference:
            params = ["invoice", "reference"]
        case .invoicePDF:
            params = ["invoice", "pdf"]
        case .paymentGetList, .paymentDelete, .paymentUpdate, .paymentAdd:
            params = ["payment"]
        case .productUpdate, .productGetList, .productAdd:
            params = ["product"]
        case .productGetCategories:
            params = ["product", "categories"]
        case .productGetDomains:
            params = ["product", "domains"]
        case.revenueAllMonths:
            params = ["revenues", "allMonths"]
        case .revenueGetYear:
            params = ["revenues", "year"]
        case .revenueGetMonth:
            params = ["revenues", "month"]
        case .staffDelete, .staffGetList, .staffGetOne, .staffUpdate:
            params = ["staff"]
        case .staffUpdatePassword:
            params = ["staff", "password"]
        case .staffUpdateProfilePicture, .staffProfilePicture:
            params = ["staff", "picture"]
        case .staffAdd:
            params = ["staff", "add"]
        case .staffLogin:
            params = ["staff", "login"]
        }
        
        return params
    }
}
