//
//  UserTest.swift
//  GestionTests
//
//  Created by Kevin Bertrand on 07/09/2022.
//

import XCTest
@testable import Gestion

final class UserTest: XCTestCase {
    var fakeNetworkManager: FakeNetworkManager!
    var userManager: UserManager!
    
    override func setUp() {
        super.setUp()
        fakeNetworkManager = FakeNetworkManager()
        userManager = UserManager(networkManager: fakeNetworkManager)
    }
    
    // MARK: Connect user
    /// Success login with correct data
    func testGivenLoginSuccessWithCorrectData_WhenConnectUser_ThenGettingError() {
        // Given
        configureManager(correctData: .login, response: .status200, status: .correctData)
        
        // When
        userManager.login(user: userToConnect())
        
        // Then
        XCTAssertNotNil(userManager.connectedUser)
    }
    
    /// Success login with incorrect data
    func testGivenLoginSuccessWithIncorrectData_WhenConnectUser_ThenGettingError() {
        // Given
        configureManager(correctData: nil, response: .status200, status: .incorrectData)
        
        // When
        userManager.login(user: userToConnect())
        
        // Then
        XCTAssertNil(userManager.connectedUser)
    }
    
    /// Wrong credentials
    func testGivenWrongCredentials_WhenConnectUser_ThenGettingError() {
        // Given
        configureManager(correctData: .login, response: .status401, status: .correctData)
        
        // When
        userManager.login(user: userToConnect())
        
        // Then
        XCTAssertNil(userManager.connectedUser)
    }
    
    /// Unknown status
    func testGivenUnknownStatusReceived_WhenConnectUser_ThenGettingError() {
        // Given
        configureManager(correctData: .login, response: .status0, status: .correctData)
        
        // When
        userManager.login(user: userToConnect())
        
        // Then
        XCTAssertNil(userManager.connectedUser)
    }
    
    /// Server error
    func testGivenServerError_WhenConnectUser_ThenGettingError() {
        // Given
        configureManager(correctData: nil, response: .status0, status: .error)
        
        // When
        userManager.login(user: userToConnect())
        
        // Then
        XCTAssertNil(userManager.connectedUser)
    }
    
    // MARK: Disconnect
    func testGivenUserDisconnected_WhenDisconnect_ThenConnectedUserFieldShouldBeNil() {
        // Given (Connect user first)
        configureManager(correctData: .login, response: .status200, status: .correctData)
        userManager.login(user: userToConnect())
        XCTAssertNotNil(userManager.connectedUser)
        
        // When
        userManager.disconnectUser()
        
        // Then
        XCTAssertNil(userManager.connectedUser)
    }
    
    // MARK: Private
    /// Configure the fake network manager
    private func configureManager(correctData: FakeResponseData.DataFiles?, response: FakeResponseData.Response, status: FakeResponseData.SessionStatus) {
        fakeNetworkManager.correctData = correctData
        fakeNetworkManager.status = status
        fakeNetworkManager.response = response
    }
    
    /// Getting user to connect
    private func userToConnect() -> User.Login {
        return .init(email: "", password: "")
    }
}
