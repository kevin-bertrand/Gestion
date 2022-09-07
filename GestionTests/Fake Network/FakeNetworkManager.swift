//
//  FakeResponseManager.swift
//  GestionTests
//
//  Created by Kevin Bertrand on 07/09/2022.
//

import Alamofire
import Foundation
@testable import Gestion

final class FakeNetworkManager: NetworkManager {
    private let fakeResponse = FakeResponseData()
    var status: FakeResponseData.SessionStatus = .correctData
    var correctData: FakeResponseData.DataFiles?
    var response: FakeResponseData.Response = .status200
    
    override func request(urlParams: [String], method: HTTPMethod, authorization: HTTPHeader?, body: Encodable?, completionHandler: @escaping ((Data?, HTTPURLResponse?, Error?)) -> Void) {
        performRequest(completionHandler: completionHandler)
    }
    
    private func performRequest(completionHandler: @escaping ((Data?, HTTPURLResponse?, Error?)) -> Void) {
        switch status {
        case .error:
            completionHandler((nil, nil, nil))
        case .incorrectData:
            completionHandler((FakeResponseData.incorrectData, response.response, Alamofire.AFError.responseSerializationFailed(reason: .inputFileNil) as Error))
        case .correctData:
            completionHandler((FakeResponseData.getCorrectData(for: correctData, with: response), response.response, nil))
        }
    }

}
