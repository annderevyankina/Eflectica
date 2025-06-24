//
//  MainScreenEndpoint.swift
//  Eflectica
//
//  Created by Анна on 18.05.2025.
//

import Foundation

enum MainScreenEndpoint: Endpoint {
    case getAllEffects
    case getEffectDetails(id: Int)
    case getEffectComments(id: Int, token: String?)

    var compositePath: String {
        switch self {
        case .getAllEffects:
            return "/api/v1/effects"
        case .getEffectDetails(let id):
            return "/api/v1/effects/\(id)"
        case .getEffectComments(let id, _):
            return "/api/v1/effects/\(id)/comments"
        }
    }

    var headers: [String: String] {
        var h = ["Content-Type": "application/json"]
        switch self {
        case .getEffectComments(_, let token):
            if let token = token {
                h["Authorization"] = "Bearer \(token)"
            }
        default:
            break
        }
        return h
    }
}

