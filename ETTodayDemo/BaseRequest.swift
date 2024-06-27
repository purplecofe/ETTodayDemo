//
//  BaseRequest.swift
//  ETTodayDemo
//
//  Created by ChongKai Huang on 2024/6/22.
//

import Foundation
import UIKit

class BaseRequest<Response> {
    class UnknownError: Error {}
    private let config = URLSessionConfiguration.default

    var urlRequest: URLRequest

    init(path: String) {
        urlRequest = URLRequest(url: URL(string: String(format: "%@/%@", API.domain, path))!)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "GET"
        urlRequest.timeoutInterval = 10
    }
    
    func execute() async throws -> Response {
        do {
            let (data, _) = try await URLSession(configuration: config).data(for: urlRequest)
            return try decode(data: data)
        } catch {
            throw error
        }
    }

    func decode(data: Data) throws -> Response {
        throw UnknownError()
    }
}
