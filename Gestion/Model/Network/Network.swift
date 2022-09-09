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
    case staffDelete
    case staffGetList
    case staffGetOne
    
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
                .invoiceUpdate,
                .paymentUpdate,
                .productUpdate:
            method = .patch
        case .clientGetList,
                .estimateGetReference, .estimateGetList, .estimateGetDetails, .estimatePDF,
                .invoiceGetOne, .invoiceGetReference, .invoiceGetList, .invoicePDF,
                .productGetList, .productGetCategories, .productGetDomains,
                .paymentGetList,
                .revenueGetYear, .revenueGetMonth, .revenueAllMonths,
                .staffGetList, .staffGetOne:
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
        case .clientUpdate, .clientGetList:
            params = ["client"]
        case .clientAdd:
            params = ["client", "add"]
        case .estimateGetDetails, .estimateUpdate:
            params = ["estimate"]
        case .estimatePDF:
            params = ["estimate", "pdf"]
        case .estimateGetReference:
            params = ["estimate", "reference"]
        case .estimateGetList:
            params = ["estimate", "list"]
        case .estimateAdd:
            params = ["estimate", "add"]
        case .estimateExportToInvoice:
            params = ["estimate", "toInvoice"]
        case .invoiceAdd, .invoiceUpdate, .invoiceGetList, .invoiceGetOne:
            params = ["invoice"]
        case .invoiceGetReference:
            params = ["invoice", "reference"]
        case .invoicePDF:
            params = ["invoice", "pdf"]
        case .paymentGetList, .paymentDelete, .paymentUpdate:
            params = ["payment"]
        case .paymentAdd:
            params = ["payment", "add"]
        case .productUpdate, .productGetList:
            params = ["product"]
        case .productAdd:
            params = ["product", "add"]
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
        case .staffDelete, .staffGetList, .staffGetOne:
            params = ["staff"]
        case .staffAdd:
            params = ["staff", "add"]
        case .staffLogin:
            params = ["staff", "login"]
        }
        
        return params
    }
}
