//
//  NetworkManager.swift
//  Gestion
//
//  Created by Kevin Bertrand on 31/08/2022.
//

import Alamofire
import Foundation
import SwiftUI

class NetworkManager: NetworkProtocol {
    // MARK: Public
    // MARK: Method
    /// Perform Alamofire request
    func request(urlParams: [String], method: HTTPMethod, authorization: HTTPHeader?, body: Encodable?, completionHandler: @escaping ((Data?, HTTPURLResponse?, Error?)) -> Void) {
        
        guard let formattedUrl = URL(string: "\(url):\(apiPort)/\(urlParams.joined(separator: "/"))") else {
            completionHandler((nil, nil, nil))
            return
        }
        
        do {
            var headers: HTTPHeaders = [
                .contentType("application/json; charset=utf-8")
            ]
            if let authorization = authorization {
                headers.add(authorization)
            }
            var request = try URLRequest(url: formattedUrl, method: method)
            if let body = body {
                request.httpBody = try JSONEncoder().encode(body)
            }
            request.headers = headers
            AF.request(request).responseData(completionHandler: { data in
                completionHandler((data.data, data.response, data.error))
            })
        } catch let error {
            print(error.localizedDescription)
            completionHandler((nil, nil, nil))
        }
    }
    
    /// Upload File
    func uploadFiles(urlParams: [String], method: HTTPMethod, token: String, file: Data, completionHandler: @escaping ((Data?, HTTPURLResponse?, Error?)) -> Void) {
        guard let formattedUrl = URL(string: "\(url):\(apiPort)/\(urlParams.joined(separator: "/"))") else {
            completionHandler((nil, nil, nil))
            return
        }
        var headers: HTTPHeaders?
        headers = ["Authorization" : "Bearer \(token)"]
        
        
        let multiPart: MultipartFormData = MultipartFormData()
        multiPart.append(file, withName: "data", fileName: "filename", mimeType: "image/jpeg" )
        if let filename = "userPicture.jpeg".data(using: .utf8) {
            multiPart.append(filename, withName: "filename")
        }
        AF.upload(multipartFormData: multiPart, to: formattedUrl, method: .patch, headers: headers)
            .response { data in
                completionHandler((data.data, data.response, data.error))
        }.resume()
    }
        
    // MARK: Private
    // MARK: Properties
    private let url = "http://api.gestion.desyntic.com"
    private let apiPort = 2565
}

protocol NetworkProtocol {
    func request(urlParams: [String], method: HTTPMethod, authorization: HTTPHeader?, body: Encodable?, completionHandler: @escaping ((Data?, HTTPURLResponse?, Error?)) -> Void)
    
    func uploadFiles(urlParams: [String], method: HTTPMethod, token: String, file: Data, completionHandler: @escaping ((Data?, HTTPURLResponse?, Error?)) -> Void)
}

