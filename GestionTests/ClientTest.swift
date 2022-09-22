//
//  ClientTest.swift
//  GestionTests
//
//  Created by Kevin Bertrand on 07/09/2022.
//

import XCTest
@testable import Gestion

final class ClientTest: XCTestCase {
    var fakeNetworkManager: FakeNetworkManager!
    var clientManager: ClientManager!
    
    override func setUp() {
        super.setUp()
        fakeNetworkManager = FakeNetworkManager()
        clientManager = ClientManager(networkManager: fakeNetworkManager)
    }
    
    // MARK: Get client list
    /// Getting list with correct data
    func testGivenCorrectData_WhenGettingClientList_ThenGetClientArray() {
        // Given
        configureManager(correctData: .clientList, response: .status200, status: .correctData)
        
        // When
        clientManager.getList(for: getConnectedUser())
        
        // Then
        XCTAssertNotEqual(clientManager.clients, [])
    }
    
    /// Getting list with incorrect data
    func testGivenIncorrectData_WhenGettingClientList_ThenGetClientArray() {
        // Given
        configureManager(correctData: nil, response: .status500, status: .incorrectData)
        
        // When
        clientManager.getList(for: getConnectedUser())
        
        // Then
        XCTAssertEqual(clientManager.clients, [])
    }
    
    // MARK: Update client
    /// Client not selected
    func testGivenClientNotSelected_WhenTryingToUpdate_ThenGettingError() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.unknownError.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status401, status: .correctData)
        
        // When
        clientManager.update(client: getClientToUpdate(correctId: false), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    /// Correct update
    func testGivenSuccessUpdate_WhenTryingToUpdate_ThenGettingSuccess() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.clientUpdated.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status200, status: .correctData)
        
        // When
        clientManager.update(client: getClientToUpdate(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    /// Unauthorized status
    func testGivenUnauthorizedUser_WhenTryingToUpdate_ThenGettingError() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.notAuthorized.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status401, status: .correctData)
        
        // When
        clientManager.update(client: getClientToUpdate(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    /// Not acceptable
    func testGivenNotAcceptable_WhenTryingToUpdate_ThenGettingError() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.clientUpdateError.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status406, status: .correctData)
        
        // When
        clientManager.update(client: getClientToUpdate(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    /// Unknown status
    func testGivenUnknownReceivedStatus_WhenTryingToUpdate_ThenGettingError() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.unknownError.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status0, status: .correctData)
        
        // When
        clientManager.update(client: getClientToUpdate(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    /// Server error
    func testGivenServerError_WhenTryingToUpdate_ThenGettingError() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.unknownError.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status0, status: .error)
        
        // When
        clientManager.update(client: getClientToUpdate(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    // MARK: Create client
    /// Succes creation
    func testGivenSuccessCreation_WhenTryingToCreateClient_ThenGettingError() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.clientCreateSuccess.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status201, status: .correctData)
        
        // When
        clientManager.create(client: getClientToCreate(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    /// Unauthorized user
    func testGivenUnauthorizedUser_WhenTryingToCreateClient_ThenGettingError() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.notAuthorized.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status401, status: .correctData)
        
        // When
        clientManager.create(client: getClientToCreate(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    /// Unknown status
    func testGivenUnknownStatusReceived_WhenTryingToCreateClient_ThenGettingError() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.unknownError.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status0, status: .correctData)
        
        // When
        clientManager.create(client: getClientToCreate(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    /// Server error
    func testGivenServerError_WhenTryingToCreateClient_ThenGettingError() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Desyntic.unknownError.notificationName, object: nil, handler: nil)
        
        // Given
        configureManager(correctData: nil, response: .status0, status: .error)
        
        // When
        clientManager.create(client: getClientToCreate(), by: getConnectedUser())
        
        // Then
        waitForExpectations(timeout: 2, handler: nil)
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
                             
    /// Get client to update
    private func getClientToUpdate(correctId: Bool = true) -> Client.Informations {
        return .init(id: correctId ? UUID(uuidString: "451FC61E-5D5F-48BE-8728-F0DE3B4AFB3C") : nil, firstname: nil, lastname: nil, company: nil, phone: "", email: "", personType: .company, gender: nil, siret: nil, tva: nil, address: Address(id: "", roadName: "", streetNumber: "", complement: nil, zipCode: "", city: "", country: "", latitude: 0, longitude: 0, comment: nil))
    }
    
    /// Get client to create
    private func getClientToCreate() -> Client.Create {
        return .init(firstname: "", lastname: "", company: "", phone: "", email: "", personType: .company, gender: .man, siret: "", tva: "", address: Address.Create(roadName: "", streetNumber: "", complement: "", zipCode: "", city: "", country: "", latitude: 0, longitude: 0, comment: ""))
    }
}
