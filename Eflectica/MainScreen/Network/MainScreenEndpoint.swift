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
    case getEffectComments(id: Int)

    var compositePath: String {
        switch self {
        case .getAllEffects:
            return "/api/v1/effects"
        case .getEffectDetails(let id):
            return "/api/v1/effects/\(id)"
        case .getEffectComments(let id):
            return "/api/v1/effects/\(id)/comments"
        case .getEffectComments:
            break // только Content-Type
        }
    }

    var headers: [String: String] {
        var h = ["Content-Type": "application/json"]
        switch self {
        case .getEffectComments:
            break // только Content-Type
        default:
            break
        }
        return h
    }
}

