//
//  Effect.swift
//  Eflectica
//
//  Created by Анна on 20.05.2025.
//

import SwiftUI
import Foundation

struct Effect: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let img: ImageData
    let description: String
    let speed: Int
    let platform: String
    let manual: String
    let programs: String
    let programVersion: String
    let categoryList: [String]
    let taskList: [String]
    let averageRating: Double
    let beforeImage: ImageData
    let afterImage: ImageData
    
    enum CodingKeys: String, CodingKey {
        case id, name, img, description, speed, platform, manual, programs
        case programVersion = "program_version"
        case categoryList = "category_list"
        case taskList = "task_list"
        case averageRating = "average_rating"
        case beforeImage = "before_image"
        case afterImage = "after_image"
    }
    
    var platformList: [String] {
        platform.components(separatedBy: ",")
    }
    
    var programList: [String] {
        programs.components(separatedBy: ",")
    }
    
    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Effect, rhs: Effect) -> Bool {
        lhs.id == rhs.id
    }
}

struct ImageData: Codable, Hashable {
    let url: String
    let q70: Q70Image
}

struct Q70Image: Codable, Hashable {
    let url: String
}
