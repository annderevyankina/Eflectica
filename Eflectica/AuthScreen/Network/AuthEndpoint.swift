//
//  AuthEndpoint.swift
//  Eflectica
//
//  Created by Анна on 09.04.2025.
//

enum AuthEndpoint: Endpoint {
    case signup
    case signin
    case users(token: String)

    var rawValue: String {
        switch self {
        case .signup:
            return "sign_up"
        case .signin:
            return "sign_in"
        case .users:
            return "users"
        }
    }

    var compositePath: String {
        return "/api/v1/\(self.rawValue)"
    }

    var headers: [String: String] {
        switch self {
        case .users(let token): ["Authorization": "Bearer \(token)"]
        default: ["Content-Type": "application/json"]
        }

    }
}
