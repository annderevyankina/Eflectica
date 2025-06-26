import Foundation

struct CommentCardViewModel: Identifiable {
    let id: Int
    let username: String
    let avatarUrl: String
    let text: String
    let dateString: String
    let currentUsername: String?

    init(comment: Comment, currentUsername: String? = nil) {
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
        self.currentUsername = currentUsername
    }

    var isMine: Bool {
        print("DEBUG isMine: username=\(username), currentUsername=\(currentUsername ?? "nil")")
        guard let current = currentUsername else { return false }
        return username == current
    }
} 