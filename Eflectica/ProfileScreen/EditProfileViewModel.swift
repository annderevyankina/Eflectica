//
//  EditProfileViewModel.swift
//  Eflectica
//
//  Created by Анна on 31.05.2025.
//

import Foundation

final class EditProfileViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var bio: String = ""
    @Published var contact: String = ""
    @Published var portfolio: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let worker = ProfileScreenWorker()
    
    func loadUserData(_ user: User) {
        username = user.username ?? ""
        bio = user.bio ?? ""
        contact = user.contact ?? ""
        portfolio = user.portfolio ?? ""
    }
    
    func saveProfile() {
        // Логика сохранения профиля
        isLoading = true
        // Вызов API для обновления профиля
    }
}
