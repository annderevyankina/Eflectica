//
//  Collection.swift
//  Eflectica
//
//  Created by Анна on 18.05.2025.
//

import Foundation
import SwiftUI
import Combine

struct Collection: Decodable, Identifiable {
    let id: Int
    let name: String
    let description: String?
    let userId: Int?
    let status: String?
    let effects: [Effect]?
    let links: [CollectionLink]?
    let images: [CollectionImage]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, status, effects, links, images
        case userId = "user_id"
    }
}

struct CollectionLink: Decodable, Identifiable {
    let id: Int
    let path: String
}

struct CollectionImage: Decodable, Identifiable {
    let id: Int
    let file: CollectionImageFile
    let title: String?
    let imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id, file, title
        case imageUrl = "image_url"
    }
}

struct CollectionImageFile: Decodable {
    let url: String
    let q70: Q70Image?
    
    struct Q70Image: Decodable {
        let url: String
    }
}

