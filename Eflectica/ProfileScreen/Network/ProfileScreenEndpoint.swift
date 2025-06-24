//
//  ProfileEndpoint.swift
//  Eflectica
//
//  Created by Анна on 18.05.2025.
//

import Foundation

enum ProfileScreenEndpoint: Endpoint {
    case getAllUsers
    case getUser(id: Int, token: String)
    case getCurrentUser(token: String)
    case patchProfile(token: String)
    case deleteProfile(token: String)

    var compositePath: String {
        switch self {
        case .getAllUsers:
            return "/api/v1/users"
        case .getUser(let id, _):
            return "/api/v1/users/\(id)"
        case .getCurrentUser:
            return "/api/v1/users/me"
        case .patchProfile:
            return "/api/v1/profiles"
        case .deleteProfile:
            return "/api/v1/profiles"
        }
    }

    var headers: [String: String] {
        var h = ["Content-Type": "application/json"]
        switch self {
        case .getAllUsers:
            break
        case .getUser(_, let token), .getCurrentUser(let token):
            h["Authorization"] = token
        case .patchProfile(let token):
            h["Authorization"] = token
        case .deleteProfile(let token):
            h["Authorization"] = token
        }
        return h
    }
}








