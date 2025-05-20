//
//  Effect.swift
//  Eflectica
//
//  Created by Анна on 20.05.2025.
//

import SwiftUI
import Foundation

struct Effect: Identifiable, Decodable {
    let id: Int
    let name: String
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
        case id, name, description, speed, platform, manual
        case programs
        case programVersion = "program_version"
        case categoryList = "category_list"
        case taskList = "task_list"
        case averageRating = "average_rating"
        case beforeImage = "before_image"
        case afterImage = "after_image"
    }
}

struct ImageData: Decodable {
    let url: String
    let q70: Q70Image
    
    enum CodingKeys: String, CodingKey {
        case url = "url"
        case q70 = "q70"
    }
}

struct Q70Image: Decodable {
    let url: String
}
