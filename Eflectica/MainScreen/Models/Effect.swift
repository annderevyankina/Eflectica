//
//  Effect.swift
//  Eflectica
//
//  Created by Анна on 20.05.2025.
//

import SwiftUI
import Foundation

struct Effect: Decodable, Identifiable {
    let id: Int
    let name: String
    let img: EffectImage
    let description: String
    let speed: Int?
    let platform: String?
    let manual: String?
    let createdAt: String?
    let url: String?
    let author: EffectAuthor?
    let categories: [String]?
    let tasks: [String]?
    let programs: [EffectProgram]?
    let averageRating: Double?
    let beforeImage: EffectImage?
    let afterImage: EffectImage?

    enum CodingKeys: String, CodingKey {
        case id, name, img, description, speed, platform, manual, url, author, categories, tasks, programs
        case createdAt = "created_at"
        case averageRating = "average_rating"
        case beforeImage = "before_image"
        case afterImage = "after_image"
    }
    
    var platformList: [String] {
        platform?.components(separatedBy: ",") ?? []
    }
    
    var programList: [String] {
        programs?.map { $0.name } ?? []
    }
}

struct EffectImage: Decodable {
    let url: String
    let q70: Q70Image?
    struct Q70Image: Decodable {
        let url: String
    }
}

struct EffectAuthor: Decodable {
    let id: Int
    let username: String
    let avatar: EffectImage
}

struct EffectProgram: Decodable {
    let name: String
    let version: String
}

// MARK: - Hashable
extension Effect: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Effect, rhs: Effect) -> Bool {
        lhs.id == rhs.id
    }
}
