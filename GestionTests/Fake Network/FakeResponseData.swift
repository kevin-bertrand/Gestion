//
//  FakeResponseData.swift
//  GestionTests
//
//  Created by Kevin Bertrand on 07/09/2022.
//

import Alamofire
import Foundation

final class FakeResponseData {
    private static let responseOK = HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    
    class ResponseError: Error {}
    static let error = ResponseError()
    
    static func getCorrectData(for dataUrl: DataFiles?, with correctResponse: Response) -> Data? {
        var data: Data?
        if let dataUrl = dataUrl {
            let bundle = Bundle(for: FakeResponseData.self)
            if let url = bundle.url(forResource: dataUrl.rawValue, withExtension: ".json") {
                data = try! Data(contentsOf: url)
            }
        }
        
        responseData.data = data
        responseData.error = nil
        responseData.response = correctResponse.response
        return data
    }
    
    static var incorrectData: Data {
        get {
            responseData.data = nil
            responseData.response = responseOK
            responseData.error = AFError.explicitlyCancelled
            return "Error".data(using: .utf8)!
        }
    }
    
    static var responseData = URLResponse()
    
    enum Response {
        case status200
        case status201
        case status401
        case status404
        case status406
        case status500
        case status0
        
        var response: HTTPURLResponse {
            switch self {
            case .status200:
                return HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            case .status201:
                return HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: 201, httpVersion: nil, headerFields: nil)!
            case .status401:
                return HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: 401, httpVersion: nil, headerFields: nil)!
            case .status404:
                return HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: 404, httpVersion: nil, headerFields: nil)!
            case .status406:
                return HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: 406, httpVersion: nil, headerFields: nil)!
            case .status500:
                return HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
            case .status0:
                return HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: 0, httpVersion: nil, headerFields: nil)!
            }
        }
    }
    
    
    enum DataFiles: String {
        case clientList = "ClientList"
        case login = "Login"
        case revenuesAllMonthsThisYear = "RevenuesAll"
        case revenuesThisMonth = "RevenuesMonth"
        case revenuesThisYear = "RevenuesYear"
    }
    
    enum SessionStatus {
        case error
        case correctData
        case incorrectData
    }
    
    struct URLResponse {
        var response: HTTPURLResponse?
        var data: Data?
        var error: Error?
    }
}
