//
//  RevenuesTest.swift
//  GestionTests
//
//  Created by Kevin Bertrand on 07/09/2022.
//

import XCTest
@testable import Gestion

final class RevenuesTest: XCTestCase {
    var fakeNetworkManager: FakeNetworkManager!
    var revenuesManager: RevenuesManager!
    
    override func setUp() {
        super.setUp()
        fakeNetworkManager = FakeNetworkManager()
        revenuesManager = RevenuesManager(networkManager: fakeNetworkManager)
    }
    
    // MARK: Getting this year revenues
    /// Correct data
    func testGivenCorrectData_WhenGettingThisYear_ThenGettingError() {
        // Given
        configureManager(correctData: .revenuesThisYear, response: .status200, status: .correctData)
        
        // When
        revenuesManager.getThisYear(for: getConnectedUser())
        
        // Then
        XCTAssertNotEqual(revenuesManager.thisYearRevenue, 0)
    }
    
    /// Server errror
    func testGivenGettingError_WhenGettingThisYear_ThenGettingError() {
        // Given
        configureManager(correctData: .revenuesThisYear, response: .status0, status: .error)
        
        // When
        revenuesManager.getThisYear(for: getConnectedUser())
        
        // Then
        XCTAssertEqual(revenuesManager.thisYearRevenue, 0)
    }
    
    // MARK: Getting this month revenues
    /// Correct data
    func testGivenCorrectData_WhenGettingThisMonth_ThenGettingError() {
        // Given
        configureManager(correctData: .revenuesThisMonth, response: .status200, status: .correctData)
        
        // When
        revenuesManager.gettingThisMonthRevenues(for: getConnectedUser())
        
        // Then
        XCTAssertNotEqual(revenuesManager.thisMonthRevenue.grandTotal, 0)
    }
    
    /// Server errror
    func testGivenServerError_WhenGettingThisMonth_ThenGettingError() {
        // Given
        configureManager(correctData: .revenuesThisMonth, response: .status0, status: .error)
        
        // When
        revenuesManager.gettingThisMonthRevenues(for: getConnectedUser())
        
        // Then
        XCTAssertEqual(revenuesManager.thisMonthRevenue.grandTotal, 0)
    }
    
    // MARK: Getting all month for this year
    /// Correct data
    func testGivenCorrectData_WhenGettingAllMonth_ThenGettingError() {
        // Given
        configureManager(correctData: .revenuesAllMonthsThisYear, response: .status200, status: .correctData)
        
        // When
        revenuesManager.getAllMonthThisYear(for: getConnectedUser())
        
        // Then
        XCTAssertEqual(revenuesManager.allMonthsThisYear.count, 12)
    }
    
    /// Server errror
    func testGivenServerError_WhenGettingAllMonth_ThenGettingError() {
        // Given
        configureManager(correctData: .revenuesAllMonthsThisYear, response: .status0, status: .error)
        
        // When
        revenuesManager.getAllMonthThisYear(for: getConnectedUser())
        
        // Then
        XCTAssertEqual(revenuesManager.allMonthsThisYear.count, 0)
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
}
