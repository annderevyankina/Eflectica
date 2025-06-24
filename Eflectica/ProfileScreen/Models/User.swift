//
//  ProfileUser.swift
//  Eflectica
//
//  Created by Анна on 21.05.2025.
//

import Foundation

struct User: Identifiable, Decodable {
    let id: Int
    let email: String
    let username: String?
    let bio: String?
    let contact: String?
    let portfolio: String?
    let isAdmin: Bool
    let name: String?         
    let avatar: Avatar?

    enum CodingKeys: String, CodingKey {
        case id, email, username, bio, contact, portfolio, name, avatar
        case isAdmin = "is_admin"
    }

    struct Avatar: Decodable {
        let url: String?
        let q70: Q70Image?

        struct Q70Image: Decodable {
            let url: String?
        }
    }
}



