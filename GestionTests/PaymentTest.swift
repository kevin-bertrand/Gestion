//
//  PaymentTest.swift
//  GestionTests
//
//  Created by Kevin Bertrand on 07/09/2022.
//

import XCTest
@testable import Gestion

final class PaymentTest: XCTestCase {
    var fakeNetworkManager: FakeNetworkManager!
    var paymentManager: PaymentManager!
    
    override func setUp() {
        super.setUp()
        fakeNetworkManager = FakeNetworkManager()
        paymentManager = PaymentManager(networkManager: fakeNetworkManager)
    }
    
    // MARK: Getting payment listing
    /// Download success
    func testGivenSuccessDownload_WhenGettingPaymentList_ThenArrayShouldBeFilled() {
        // Given
        configureManager(correctData: .paymentsList, response: .status200, status: .correctData)
        
        // When
        paymentManager.gettingPaymentList(by: getConnectedUser())
        
        // Then
        XCTAssertNotEqual(paymentManager.payments.count, 0)
    }
    
    /// Server error
    func testGivenServerError_WhenGettingPaymentList_ThenArrayShouldNotBeFilled() {
        // Given
        configureManager(correctData: .paymentsList, response: .status200, status: .error)
        
        // When
        paymentManager.gettingPaymentList(by: getConnectedUser())
        
        // Then
        XCTAssertEqual(paymentManager.payments.count, 0)
    }
    
    // MARK: Update payment
    /// Success update
    func testGivenSuccessUpdate_WhenUpdatingPayment_ThenSuccessNotificationShouldBeTriggered() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.paymentUpdateSuccess.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status200, status: .correctData)
        
        // When
        paymentManager.update(method: getUpdatePayment(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    /// Unauthorized update
    func testGivenUnauthorizedUpdate_WhenUpdatingPayment_ThenErrorNotificationShouldBeTriggered() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.notAuthorized.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status401, status: .correctData)
        
        // When
        paymentManager.update(method: getUpdatePayment(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    /// Unknown status
    func testGivenUnknownUpdate_WhenUpdatingPayment_ThenErrorNotificationShouldBeTriggered() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.unknownError.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status0, status: .correctData)
        
        // When
        paymentManager.update(method: getUpdatePayment(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    /// Server errror
    func testGivenServerError_WhenUpdatingPayment_ThenErrorNotificationShouldBeTriggered() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.unknownError.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status0, status: .error)
        
        // When
        paymentManager.update(method: getUpdatePayment(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    // MARK: Create payment
    /// Success creation
    func testGivenSuccessCreation_WhenCreatePayment_ThenSuccessNotificationShouldBeTriggered() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.paymentCreationSuccess.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status201, status: .correctData)
        
        // When
        paymentManager.create(method: getCreatePayment(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    /// Unauthorized creation
    func testGivenUnauthorizedCreation_WhenCreatePayment_ThenErrorNotificationShouldBeTriggered() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.notAuthorized.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status401, status: .correctData)
        
        // When
        paymentManager.create(method: getCreatePayment(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    /// Unknown status
    func testGivenUnknownStatus_WhenCreatePayment_ThenErrorNotificationShouldBeTriggered() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.unknownError.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status0, status: .correctData)
        
        // When
        paymentManager.create(method: getCreatePayment(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    /// Server errror
    func testGivenServerError_WhenCreatePayment_ThenErrorNotificationShouldBeTriggered() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.unknownError.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status0, status: .error)
        
        // When
        paymentManager.create(method: getCreatePayment(), by: getConnectedUser())
        
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
    
    /// Getting a payment to update
    private func getUpdatePayment() -> Payment {
        return .init(id: UUID(uuid: UUID_NULL), title: "", iban: "", bic: "")
    }
    
    /// Getting a payment to create
    private func getCreatePayment() -> Payment.Create {
        return .init(title: "", iban: "", bic: "")
    }
}
