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
        self.id = comment.id
        self.username = comment.user.username ?? ""
        self.avatarUrl = comment.user.avatar.url ?? ""
        self.text = comment.body
        // Форматируем дату для отображения
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        self.dateString = formatter.string(from: comment.createdAt)
    }
}

