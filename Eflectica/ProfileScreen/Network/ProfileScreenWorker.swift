//
//  ProfileScreenWorker.swift
//  Eflectica
//
//  Created by Анна on 18.05.2025.
//

import Foundation

/// Специальные ошибки для профиля с описанием
enum ProfileError: LocalizedError {
    case invalidURL
    case noResponse
    case apiError(statusCode: Int, body: String)
    case decodingError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Неверный URL"
        case .noResponse:
            return "Нет ответа от сервера"
        case .apiError(let status, let body):
            return "Сервер вернул ошибку \(status): \(body)"
        case .decodingError(let err):
            return "Ошибка разбора данных: \(err.localizedDescription)"
        }
    }
}

final class ProfileScreenWorker {
    private let baseURL = "http://localhost:3000"

    /// Получить текущего пользователя по токену с подробным логированием
    func fetchCurrentUser(token: String,
                          completion: @escaping (Result<User, Error>) -> Void) {
        let endpoint = ProfileScreenEndpoint.getCurrentUser(token: token)
        let urlString = baseURL + endpoint.compositePath
        print("→ Request URL: \(urlString)")

        guard let url = URL(string: urlString) else {
            print("🛑 Error: invalid URL")
            return completion(.failure(ProfileError.invalidURL))
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        endpoint.headers.forEach { header, value in
            request.setValue(value, forHTTPHeaderField: header)
        }
        print("→ Request Headers:", request.allHTTPHeaderFields ?? [:])
        print("→ Token for request:", token)

        URLSession.shared.dataTask(with: request) { data, response, error in
            // 1. Сетевая ошибка
            if let error = error {
                print("🛑 Network error:", error)
                return DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }

            // 2. HTTP-ответ и данные
            guard let http = response as? HTTPURLResponse, let data = data else {
                print("🛑 Error: no HTTP response or data")
                return DispatchQueue.main.async {
                    completion(.failure(ProfileError.noResponse))
                }
            }
            print("➡️ HTTP status code:", http.statusCode)

            // 3. Сырые данные
            let rawBody = String(data: data, encoding: .utf8) ?? "<non-UTF8 data>"
            print("📥 Raw response:\n\(rawBody)")

            // 4. Ошибка уровня API
            guard (200...299).contains(http.statusCode) else {
                let apiErr = ProfileError.apiError(statusCode: http.statusCode, body: rawBody)
                print("🛑 API error:", apiErr.errorDescription ?? "")
                return DispatchQueue.main.async {
                    completion(.failure(apiErr))
                }
            }

            // 5. Декодирование модели User
            do {
                let decoder = JSONDecoder()
                // УБРАЛИ: decoder.keyDecodingStrategy = .convertFromSnakeCase
                let user = try decoder.decode(User.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(user))
                }
            } catch {
                print("🛑 Decoding error:", error)
                DispatchQueue.main.async {
                    completion(.failure(ProfileError.decodingError(error)))
                }
            }
        }
        .resume()
    }
}

