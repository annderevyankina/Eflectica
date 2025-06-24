//
//  CollectionsScreenEndpoint.swift
//  Eflectica
//
//  Created by Анна on 18.05.2025.
//

import Foundation

enum CollectionsScreenEndpoint: Endpoint {
    case myCollections
    case subCollections
    case allCollections
    
    var compositePath: String {
        switch self {
        case .myCollections:
            return "/api/v1/collections/my"
        case .subCollections:
            return "/api/v1/sub_collections"
        case .allCollections:
            return "/api/v1/collections"
        }
    }
    
    var headers: [String: String] {
        ["Content-Type": "application/json"]
    }
}

