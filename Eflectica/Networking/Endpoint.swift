//
//  Endpoint.swift
//  HealthyWeather
//
//  Created by Grigory Sosnovskiy on 06.08.2024.
//

protocol Endpoint {
    var compositePath: String { get }
    var headers: [String: String] { get }
    var parameters: [String: String]? { get }
}

extension Endpoint {
    var parameters: [String: String]? {
        nil
    }
}
