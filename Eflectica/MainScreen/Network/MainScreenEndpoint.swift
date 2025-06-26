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
    case deleteEffect(id: Int)
    case getEffectComments(id: Int)
    case postEffectComment(effectId: Int, token: String)
    case deleteEffectComment(effectId: Int, commentId: Int, token: String)

    var compositePath: String {
        switch self {
        case .getAllEffects:
            return "/api/v1/effects"
        case .getEffectDetails(let id):
            return "/api/v1/effects/\(id)"
        case .deleteEffect(let id):
            return "/api/v1/effects/\(id)"
        case .getEffectComments(let id):
            return "/api/v1/effects/\(id)/comments"
        case .postEffectComment(let effectId, _):
            return "/api/v1/effects/\(effectId)/comments"
        case .deleteEffectComment(let effectId, let commentId, _):
            return "/api/v1/effects/\(effectId)/comments/\(commentId)"
        }
    }

    var headers: [String: String] {
        var h = ["Content-Type": "application/json"]
        switch self {
        case .postEffectComment(_, let token):
            h["Authorization"] = "Bearer \(token)"
        case .deleteEffectComment(_, _, let token):
            h["Authorization"] = "Bearer \(token)"
        default:
            break
        }
        return h
    }
}

