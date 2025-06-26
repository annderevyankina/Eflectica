//
//  CollectionsScreenEndpoint.swift
//  Eflectica
//
//  Created by Анна on 18.05.2025.
//

import Foundation

enum CollectionsScreenEndpoint: Endpoint, Equatable {
    case myCollections
    case subCollections
    case allCollections
    case createCollection
    case updateCollection(id: Int)
    case deleteCollection(id: Int)
    case addEffect(collectionId: Int, effectId: Int)
    case deleteEffect(collectionId: Int, effectId: Int)
    case addLink(collectionId: Int)
    case updateLink(collectionId: Int, linkId: Int)
    case deleteLink(collectionId: Int, linkId: Int)
    case addImage(collectionId: Int)
    case updateImage(collectionId: Int, imageId: Int)
    case deleteImage(collectionId: Int, imageId: Int)
    
    var compositePath: String {
        switch self {
        case .myCollections:
            return "/api/v1/collections/my"
        case .subCollections:
            return "/api/v1/sub_collections"
        case .allCollections:
            return "/api/v1/collections"
        case .createCollection:
            return "/api/v1/collections"
        case .updateCollection(let id):
            return "/api/v1/collections/\(id)"
        case .deleteCollection(let id):
            return "/api/v1/collections/\(id)"
        case .addEffect(let collectionId, let effectId):
            return "/api/v1/collections/\(collectionId)/effects/\(effectId)"
        case .deleteEffect(let collectionId, let effectId):
            return "/api/v1/collections/\(collectionId)/effects/\(effectId)"
        case .addLink(let collectionId):
            return "/api/v1/collections/\(collectionId)/links"
        case .updateLink(let collectionId, let linkId):
            return "/api/v1/collections/\(collectionId)/links/\(linkId)"
        case .deleteLink(let collectionId, let linkId):
            return "/api/v1/collections/\(collectionId)/links/\(linkId)"
        case .addImage(let collectionId):
            return "/api/v1/collections/\(collectionId)/images"
        case .updateImage(let collectionId, let imageId):
            return "/api/v1/collections/\(collectionId)/images/\(imageId)"
        case .deleteImage(let collectionId, let imageId):
            return "/api/v1/collections/\(collectionId)/images/\(imageId)"
        }
    }
    
    var headers: [String: String] {
        ["Content-Type": "application/json"]
    }
}

