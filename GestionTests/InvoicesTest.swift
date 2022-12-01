//
//  InvoicesTest.swift
//  GestionTests
//
//  Created by Kevin Bertrand on 07/09/2022.
//

import XCTest
@testable import Gestion

final class InvoicesTest: XCTestCase {
    var fakeNetworkManager: FakeNetworkManager!
    var invoicesManager: InvoicesManager!
    
    override func setUp() {
        super.setUp()
        fakeNetworkManager = FakeNetworkManager()
        invoicesManager = InvoicesManager(networkManager: fakeNetworkManager)
    }
    
    // MARK: Getting new invoice reference
    /// Success getting reference
    func testGivenSuccess_WhenGettingReference_ThenSuccessNotification() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.invoicesGettingReference.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: .invoiceReference, response: .status200, status: .correctData)
        
        // When
        invoicesManager.gettingNewReference(for: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    /// Server error
    func testGivenError_WhenGettingReference_ThenSuccessNotification() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.unknownError.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: .invoiceReference, response: .status200, status: .error)
        
        // When
        invoicesManager.gettingNewReference(for: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    // MARK: Download three latest invoices
    /// Success downlaod
    func testGivenSuccessDownload_WhenGettingLatestsInvoices_ThenSuccessNotification() {
        // Given
        configureManager(correctData: .invoiceThreeLatest, response: .status200, status: .correctData)
        
        // When
        invoicesManager.downloadThreeLatests(for: getConnectedUser())
        
        // Then
        XCTAssertNotEqual(invoicesManager.invoicesSummary.count, 0)
    }
    
    /// Server error
    func testGivenServerError_WhenGettingLatestsInvoices_ThenErrorNotification() {
        // Given
        configureManager(correctData: .invoiceThreeLatest, response: .status200, status: .error)
        
        // When
        invoicesManager.downloadThreeLatests(for: getConnectedUser())
        
        // Then
        XCTAssertEqual(invoicesManager.invoicesSummary.count, 0)
    }
    
    // MARK: Download all invoices
    /// Success downlaod
    func testGivenSuccessDownload_WhenGettingAllInvoices_ThenSuccessNotification() {
        // Given
        configureManager(correctData: .invoiceAll, response: .status200, status: .correctData)
        
        // When
        invoicesManager.downloadAllInvoiceSummary(for: getConnectedUser())
        
        // Then
        XCTAssertNotEqual(invoicesManager.invoicesList.count, 0)
    }
    
    /// Server error
    func testGivenServerError_WhenGettingAllInvoices_ThenErrorNotification() {
        // Given
        configureManager(correctData: .invoiceAll, response: .status200, status: .error)
        
        // When
        invoicesManager.downloadAllInvoiceSummary(for: getConnectedUser())
        
        // Then
        XCTAssertEqual(invoicesManager.invoicesList.count, 0)
    }
    
    // MARK: Download invoice detail
    /// Success download with correct data
    func testGivenSuccessDownload_WhenGettingInvoiceDetail_ThenDetailsShouldBeFilled() {
        // Given
        configureManager(correctData: .invoiceDetails, response: .status200, status: .correctData)
        
        // When
        invoicesManager.downloadInvoiceDetails(id: UUID(uuid: UUID_NULL), for: getConnectedUser())
        
        // Then
        XCTAssertNotEqual(invoicesManager.invoiceDetail.id, UUID(uuid: UUID_NULL))
    }
    
    /// Success download with incorrect data
    func testGivenSuccessDownloadWithIncorrectData_WhenGettingInvoiceDetail_ThenDetailsShouldBeFilled() {
        // Given
        configureManager(correctData: .invoiceDetails, response: .status200, status: .incorrectData)
        
        // When
        invoicesManager.downloadInvoiceDetails(id: UUID(uuid: UUID_NULL), for: getConnectedUser())
        
        // Then
        XCTAssertEqual(invoicesManager.invoiceDetail.id, UUID(uuid: UUID_NULL))
    }
    
    /// Unauthorized user
    func testGivenUnauthorizedUser_WhenGettingInvoiceDetail_ThenDetailsShouldNotBeFilled() {
        // Given
        configureManager(correctData: .invoiceDetails, response: .status404, status: .correctData)
        
        // When
        invoicesManager.downloadInvoiceDetails(id: UUID(uuid: UUID_NULL), for: getConnectedUser())
        
        // Then
        XCTAssertEqual(invoicesManager.invoiceDetail.id, UUID(uuid: UUID_NULL))
    }
    
    /// Unknown status
    func testGivenUnknownStatus_WhenGettingInvoiceDetail_ThenDetailsShouldNotBeFilled() {
        // Given
        configureManager(correctData: .invoiceDetails, response: .status0, status: .correctData)
        
        // When
        invoicesManager.downloadInvoiceDetails(id: UUID(uuid: UUID_NULL), for: getConnectedUser())
        
        // Then
        XCTAssertEqual(invoicesManager.invoiceDetail.id, UUID(uuid: UUID_NULL))
    }
    
    /// Server error
    func testGivenServerError_WhenGettingInvoiceDetail_ThenDetailsShouldNotBeFilled() {
        // Given
        configureManager(correctData: .invoiceDetails, response: .status0, status: .error)
        
        // When
        invoicesManager.downloadInvoiceDetails(id: UUID(uuid: UUID_NULL), for: getConnectedUser())
        
        // Then
        XCTAssertEqual(invoicesManager.invoiceDetail.id, UUID(uuid: UUID_NULL))
    }
    
    // MARK: Create invoice
    /// Success creation
    func testGivenSuccessCreation_WhenCreateInvoice_ThenSuccessNotificationShouldBeTriggered() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.invoicesCreated.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status201, status: .correctData)
        
        // When
        invoicesManager.create(invoice: getInvoiceToCreate(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    /// Error creation
    func testGivenErrorCreation_WhenCreateInvoice_ThenErrorNotificationShouldBeTriggered() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.invoicesFailedCreated.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status500, status: .correctData)
        
        // When
        invoicesManager.create(invoice: getInvoiceToCreate(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    /// Unknown status
    func testGivenUnknownStatus_WhenCreateInvoice_ThenErrorNotificationShouldBeTriggered() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.unknownError.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status0, status: .correctData)
        
        // When
        invoicesManager.create(invoice: getInvoiceToCreate(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    /// Server error
    func testGivenServerError_WhenCreateInvoice_ThenErrorNotificationShouldBeTriggered() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.unknownError.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status0, status: .error)
        
        // When
        invoicesManager.create(invoice: getInvoiceToCreate(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    // MARK: Update invoice
    /// Success update
    func testGivenSuccessUpdate_WhenUpdateInvoice_ThenSuccessNotificationShouldBeTriggered() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.invoicesUpdateSuccess.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status200, status: .correctData)
        
        // When
        invoicesManager.update(invoice: getInvoiceToUpdate(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    /// Error update
    func testGivenErrorUpdate_WhenUpdateInvoice_ThenErrorNotificationShouldBeTriggered() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.invoicesUpdateFailed.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status500, status: .correctData)
        
        // When
        invoicesManager.update(invoice: getInvoiceToUpdate(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    /// Unknown status
    func testGivenUnknownStatus_WhenUpdateInvoice_ThenErrorNotificationShouldBeTriggered() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.unknownError.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status0, status: .correctData)
        
        // When
        invoicesManager.update(invoice: getInvoiceToUpdate(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    /// Server error
    func testGivenServerError_WhenUpdateInvoice_ThenErrorNotificationShouldBeTriggered() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.unknownError.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status0, status: .error)
        
        // When
        invoicesManager.update(invoice: getInvoiceToUpdate(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    // MARK: Private
    /// Configure the fake network manager
    private func configureManager(correctData: FakeResponseData.DataFiles?, response: FakeResponseData.Response, status: FakeResponseData.SessionStatus) {
        fakeNetworkManager.correctData = correctData
        fakeNetworkManager.status = status
        fakeNetworkManager.response = response
    }

    /// Connect a user
    private func getConnectedUser() -> User {
        return User(id: UUID(), phone: "", gender: .man, position: .leadingBoard, lastname: "", role: "", firstname: "", email: "", token: "", permissions: "", address: .init(id: "", roadName: "", streetNumber: "", complement: "", zipCode: "", city: "", country: "", latitude: 0, longitude: 0, comment: ""))
    }
    
    /// Getting invoice to create
    private func getInvoiceToCreate() -> Invoice.Create {
        return .init(reference: "", internalReference: "", object: "", totalServices: 0, totalMaterials: 0, totalDivers: 0, total: 0, grandTotal: 0, status: .inCreation, limitPayementDate: "", clientID: UUID(uuid: UUID_NULL), products: [])
    }
    
    /// Getting incoive to update
    private func getInvoiceToUpdate() -> Invoice.Update {
        return .init(id: UUID(uuid: UUID_NULL), reference: "", internalReference: "", object: "", totalServices: 0, totalMaterials: 0, totalDivers: 0, total: 0, grandTotal: 0, status: .inCreation, facturationDate: Date().ISO8601Format(), products: [])
    }
}
