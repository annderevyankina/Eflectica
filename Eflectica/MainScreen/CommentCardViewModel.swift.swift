//
//  CommentCardViewModel.swift.swift
//  Eflectica
//
//  Created by Анна on 24.06.2025.
//

import Foundation

struct CommentCardViewModel: Identifiable {
    let id: Int
    let username: String
    let avatarUrl: String
    let text: String
    let dateString: String

    init(comment: Comment) {
        self.id = comment.id ?? 0
        self.username = comment.user?.username ?? ""
        if let q70url = comment.user?.avatar?.q70?.url {
            self.avatarUrl = q70url
        } else if let url = comment.user?.avatar?.url {
            self.avatarUrl = url
        } else {
            self.avatarUrl = ""
        }
        self.text = comment.body ?? ""
        // Форматируем дату для отображения
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        if let date = comment.createdAt {
            self.dateString = formatter.string(from: date)
        } else {
            self.dateString = ""
        }
    }
}

