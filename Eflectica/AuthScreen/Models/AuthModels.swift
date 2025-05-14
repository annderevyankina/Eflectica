//
//  AuthModels.swift
//  Eflectica
//
//  Created by Анна on 09.04.2025.
//
import SwiftUI

enum Signup {
    struct Request: Encodable {
        let user: UserData

        struct UserData: Encodable {
            var email: String
            var password: String
        }
    }

    struct Response: Decodable {
        let jwt: String
    }
}

enum Signin {
    struct Request: Encodable {
        let user: UserData

        struct UserData: Encodable {
            var email: String
            var password: String
        }
    }

    struct Response: Decodable {
        let jwt: String
    }
}


