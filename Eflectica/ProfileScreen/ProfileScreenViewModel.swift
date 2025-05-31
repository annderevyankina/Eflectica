//
//  ProfileScreenViewModel.swift
//  Eflectica
//
//  Created by Анна on 18.05.2025.
//

import Foundation

final class ProfileScreenViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let worker = ProfileScreenWorker()

    /// Загружает профиль текущего пользователя по токену
    func loadCurrentUser(token: String) {
        // Логируем токен для отладки
        print("ProfileScreenViewModel – token:", token)

        user = nil
        errorMessage = nil
        isLoading = true

        worker.fetchCurrentUser(token: token) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false

                switch result {
                case .success(let user):
                    self?.user = user

                case .failure(let error):
                    // Если API вернул ошибку с body в userInfo
                    if let ns = error as NSError?,
                       let body = ns.userInfo["body"] as? String {
                        self?.errorMessage = body
                    } else {
                        self?.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
}

