//
//  ProductsTest.swift
//  GestionTests
//
//  Created by Kevin Bertrand on 07/09/2022.
//

import XCTest
@testable import Gestion

final class ProductsTest: XCTestCase {
    var fakeNetworkManager: FakeNetworkManager!
    var productsManager: ProductManager!
    
    override func setUp() {
        super.setUp()
        fakeNetworkManager = FakeNetworkManager()
        productsManager = ProductManager(networkManager: fakeNetworkManager)
    }
    
    // MARK: Getting product list
    /// Success download
    func testGivenSuccessDownload_WhenDownloadingProductList_ThenArrayShouldBeFilled() {
        // Given
        configureManager(correctData: .productsList, response: .status200, status: .correctData)
        
        // When
        productsManager.gettingProductList(for: getConnectedUser())
        
        // Then
        XCTAssertNotEqual(productsManager.products.count, 0)
    }
    
    /// Server error
    func testGivenServerError_WhenDownloadingProductList_ThenArrayShouldNotBeFilled() {
        // Given
        configureManager(correctData: .productsList, response: .status200, status: .error)
        
        // When
        productsManager.gettingProductList(for: getConnectedUser())
        
        // Then
        XCTAssertEqual(productsManager.products.count, 0)
    }
    
    // MARK: Update product
    /// Sucess update
    func testGivenSuccessUpdate_WhenUpdatingProduct_ThenSuccessNotificationShouldPop() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.productsUpdateSuccess.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status200, status: .correctData)
        
        // When
        productsManager.updateProduct(getUpdateProduct(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    /// Unauthorized
    func testGivenUnauthorizedUpdate_WhenUpdatingProduct_ThenErrorNotificationShouldPop() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.notAuthorized.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status401, status: .correctData)
        
        // When
        productsManager.updateProduct(getUpdateProduct(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    /// Unknown status
    func testGivenUnknownStatus_WhenUpdatingProduct_ThenErrorNotificationShouldPop() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.unknownError.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status0, status: .correctData)
        
        // When
        productsManager.updateProduct(getUpdateProduct(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    /// Server error
    func testGivenServerError_WhenUpdatingProduct_ThenErrorNotificationShouldPop() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.unknownError.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status0, status: .error)
        
        // When
        productsManager.updateProduct(getUpdateProduct(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    // MARK: Create product
    /// Sucess creation
    func testGivenSuccessCreation_WhenCreateProduct_ThenSuccessNotificationShouldBeTriggered() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.productsCreateSuccess.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status201, status: .correctData)
        
        // When
        productsManager.create(getCreateProduct(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    /// Unauthorized
    func testGivenUnautgorizedCreation_WhenCreateProduct_ThenErrorNotificationShouldBeTriggered() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.notAuthorized.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status401, status: .correctData)
        
        // When
        productsManager.create(getCreateProduct(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    /// Unknown status
    func testGivenUnknownStatus_WhenCreateProduct_ThenErrorNotificationShouldBeTriggered() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.unknownError.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status0, status: .correctData)
        
        // When
        productsManager.create(getCreateProduct(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    /// Server error
    func testGivenServerError_WhenCreateProduct_ThenErrorNotificationShouldBeTriggered() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.unknownError.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status401, status: .error)
        
        // When
        productsManager.create(getCreateProduct(), by: getConnectedUser())
        
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
        return User(id: UUID(), phone: "", gender: .man, position: .leadingBoard, lastname: "", role: "", firstname: "", email: "", token: "", permissions: "", address: Address(id: "", roadName: "", streetNumber: "", complement: "", zipCode: "", city: "", country: "", latitude: 0, longitude: 0, comment: ""))
    }
    
    /// Getting product to update
    private func getUpdateProduct() -> Product {
        return .init(id: UUID(uuid: UUID_NULL), productCategory: .divers, title: "", domain: .automation, unity: "", price: 0)
    }
    
    /// Getting product to create
    private func getCreateProduct() -> Product.Create {
        return .init(productCategory: .divers, title: "", domain: .automation, unity: "", price: 0)
    }
}
