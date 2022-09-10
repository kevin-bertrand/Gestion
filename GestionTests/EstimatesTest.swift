//
//  EstimatesTest.swift
//  GestionTests
//
//  Created by Kevin Bertrand on 07/09/2022.
//

import XCTest
@testable import Gestion

final class EstimatesTest: XCTestCase {
    var fakeNetworkManager: FakeNetworkManager!
    var estimatesManager: EstimatesManager!
    
    override func setUp() {
        super.setUp()
        fakeNetworkManager = FakeNetworkManager()
        estimatesManager = EstimatesManager(networkManager: fakeNetworkManager)
    }
    
    // MARK: Getting new estimate reference
    /// Success getting reference
    func testGivenSuccess_WhenGettingReference_ThenSuccessNotification() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.estimateGettingReference.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: .estimateReference, response: .status200, status: .correctData)
        
        // When
        estimatesManager.gettingNewReference(by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    /// Server error
    func testGivenError_WhenGettingReference_ThenSuccessNotification() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.unknownError.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: .estimateReference, response: .status200, status: .error)
        
        // When
        estimatesManager.gettingNewReference(by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    // MARK: Create estimate
    /// Success creation
    func testGivenSuccessCreation_WhenCreateEstimate_ThenSuccessNotification() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.estimateCreated.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status201, status: .correctData)
        
        // When
        estimatesManager.create(estimate: getCreateEstimate(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    /// Error creation
    func testGivenErrorCreation_WhenCreateEstimate_ThenErrorNotification() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.estimateFailedCreated.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status500, status: .correctData)
        
        // When
        estimatesManager.create(estimate: getCreateEstimate(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    /// Unknown status
    func testGivenUnknownStatus_WhenCreateEstimate_ThenErrorNotification() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.unknownError.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status0, status: .correctData)
        
        // When
        estimatesManager.create(estimate: getCreateEstimate(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    /// Server error
    func testGivenServerError_WhenCreateEstimate_ThenErrorNotification() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.unknownError.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status0, status: .error)
        
        // When
        estimatesManager.create(estimate: getCreateEstimate(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    // MARK: Download 3 latest
    /// Success download
    func testGivenSuccessDownload_WhenGettingLatestEstimates_ThenArrayShouldBeFilled() {
        // Given
        configureManager(correctData: .estimateThreeLatest, response: .status200, status: .correctData)
        
        // When
        estimatesManager.downloadThreeLatests(for: getConnectedUser())
        
        // Then
        XCTAssertNotEqual(estimatesManager.estimatesSummary.count, 0)
    }
    
    /// Server error
    func testGivenServerError_WhenGettingLatestEstimates_ThenArrayShouldBeFilled() {
        // Given
        configureManager(correctData: .estimateThreeLatest, response: .status200, status: .error)
        
        // When
        estimatesManager.downloadThreeLatests(for: getConnectedUser())
        
        // Then
        XCTAssertEqual(estimatesManager.estimatesSummary.count, 0)
    }
    
    // MARK: Download all estimates
    /// Success download
    func testGivenSuccessDownload_WhenGettingAllEstimates_ThenArrayShouldBeFilled() {
        // Given
        configureManager(correctData: .estimateAll, response: .status200, status: .correctData)
        
        // When
        estimatesManager.downloadAllEstimates(for: getConnectedUser())
        
        // Then
        XCTAssertNotEqual(estimatesManager.estimatesList.count, 0)
    }
    
    /// Server error
    func testGivenServerError_WhenGettingAllEstimates_ThenArrayShouldBeFilled() {
        // Given
        configureManager(correctData: .estimateAll, response: .status200, status: .error)
        
        // When
        estimatesManager.downloadAllEstimates(for: getConnectedUser())
        
        // Then
        XCTAssertEqual(estimatesManager.estimatesList.count, 0)
    }
    
    // MARK: Download details
    /// Success download
    func testGivenSuccessDownload_WhenGettingEstimateDetails_ThenArrayShouldBeFilled() {
        // Given
        configureManager(correctData: .estimateDetails, response: .status200, status: .correctData)
        
        // When
        estimatesManager.downloadEstimateDetails(id: UUID(uuid: UUID_NULL), for: getConnectedUser())
        
        // Then
        XCTAssertNotEqual(estimatesManager.estimateDetail.id, UUID(uuid: UUID_NULL))
    }
    
    /// Server error
    func testGivenServerError_WhenGettingEstimateDetails_ThenArrayShouldBeFilled() {
        // Given
        configureManager(correctData: .estimateDetails, response: .status200, status: .error)
        
        // When
        estimatesManager.downloadEstimateDetails(id: UUID(uuid: UUID_NULL), for: getConnectedUser())
        
        // Then
        XCTAssertEqual(estimatesManager.estimateDetail.id, UUID(uuid: UUID_NULL))
    }
    
    // MARK: Update estimate
    /// Sucess update
    func testGivenSuccessUpdate_WhenUpdate_ThenGettingSuccessNotification() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.estimateUpdated.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status200, status: .correctData)
        
        // When
        estimatesManager.update(estimate: getEstimateToUpdate(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    /// Error update
    func testGivenErrorStatus_WhenUpdate_ThenGettingErrorNotification() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.estimateErrorUpdate.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status500, status: .correctData)
        
        // When
        estimatesManager.update(estimate: getEstimateToUpdate(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    /// Unknown status
    func testGivenUnknownStatus_WhenUpdate_ThenGettingErrorNotification() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.unknownError.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status0, status: .correctData)
        
        // When
        estimatesManager.update(estimate: getEstimateToUpdate(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    /// Server error
    func testGivenServerError_WhenUpdate_ThenGettingErrorNotification() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.unknownError.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status0, status: .error)
        
        // When
        estimatesManager.update(estimate: getEstimateToUpdate(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    // MARK: Export to invoice
    /// Export succes
    func testGivenSuccessExport_WhenExportToInvoice_ThenGettingSuccessNotification() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.estimateExportToInvoiceSuccess.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status201, status: .correctData)
        
        // When
        estimatesManager.exportToInvoice(estimate: "", by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    /// Unauthorized user
    func testGivenEstimateNotFound_WhenExportToInvoice_ThenGettingErrorNotification() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.notFound.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status404, status: .correctData)
        
        // When
        estimatesManager.exportToInvoice(estimate: "", by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    /// Unknown status
    func testGivenUnknownStatus_WhenExportToInvoice_ThenGettingErrorNotification() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.unknownError.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status0, status: .correctData)
        
        // When
        estimatesManager.exportToInvoice(estimate: "", by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    /// Server error
    func testGivenServerError_WhenExportToInvoice_ThenGettingErrorNotification() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.unknownError.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status0, status: .error)
        
        // When
        estimatesManager.exportToInvoice(estimate: "", by: getConnectedUser())
        
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
        return User(phone: "", gender: .man, position: .leadingBoard, lastname: "", role: "", firstname: "", email: "", token: "", permissions: "", address: Address(id: "", roadName: "", streetNumber: "", complement: "", zipCode: "", city: "", country: "", latitude: 0, longitude: 0, comment: ""))
    }
                                
    /// Getting estimate to create
    private func getCreateEstimate() -> Estimate.Create {
        return .init(reference: "", internalReference: "", object: "", totalServices: 0, totalMaterials: 0, totalDivers: 0, total: 0, reduction: 0, grandTotal: 0, status: .accepted, clientID: UUID(uuid: UUID_NULL), products: [])
    }
    
    /// Getting estimate to update
    private func getEstimateToUpdate() -> Estimate.Update {
        return .init(id: UUID(uuid: UUID_NULL), reference: "", internalReference: "", object: "", totalServices: 0, totalMaterials: 0, totalDivers: 0, total: 0, reduction: 0, grandTotal: 0, status: .accepted, products: [])
    }
}
