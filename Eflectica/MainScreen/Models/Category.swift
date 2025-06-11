import Foundation

struct Category: Identifiable, Hashable {
    let id: String // Идентификатор с сервера
    let name: String // Название для отображения
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Category, rhs: Category) -> Bool {
        lhs.id == rhs.id
    }
} 