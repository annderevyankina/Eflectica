//
//  Comment.swift
//  Eflectica
//
//  Created by Анна on 24.06.2025.
//

import Foundation

struct Comment: Identifiable, Decodable {
    let id: Int?
    let body: String?
    let createdAt: Date?
    let user: User?
    let replies: [Comment]?

    enum CodingKeys: String, CodingKey {
        case id
        case body
        case createdAt = "created_at"
        case user
        case replies
    }

    struct User: Decodable {
        let username: String?
        let avatar: Avatar?

        struct Avatar: Decodable {
            let url: String?
            let q70: Q70Url?

            struct Q70Url: Decodable {
                let url: String?
            }
        }
    }
}

