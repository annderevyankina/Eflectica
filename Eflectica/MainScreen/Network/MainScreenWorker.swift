//
//  MainScreenWorker.swift
//  Eflectica
//
//  Created by Анна on 18.05.2025.
//

import Foundation

final class MainScreenWorker {
    let worker = BaseURLWorker(baseUrl: "http://localhost:3000")
    
    func fetchAllEffects(completion: @escaping (Result<[Effect], Error>) -> Void) {
        let request = Request(endpoint: MainScreenEndpoint.getAllEffects, method: .get)
        print("➡️ Отправка запроса: \(request)")
        worker.executeRequest(with: request) { response in
            switch response {
            case .failure(let error):
                print("❌ Ошибка сетевого запроса: \(error)")
                completion(.failure(error))
            case .success(let result):
                if let httpResponse = result.response as? HTTPURLResponse {
                    print("⬅️ Статус ответа: \(httpResponse.statusCode)")
                    print("⬅️ Заголовки ответа: \(httpResponse.allHeaderFields)")
                } else {
                    print("⚠️ Нет HTTPURLResponse")
                }
                guard let data = result.data else {
                    print("❌ Данные не получены")
                    completion(.failure(Networking.Error.emptyData))
                    return
                }
                print("⬅️ Получено сырых данных: \(String(data: data, encoding: .utf8) ?? "nil")")
                do {
                    let effects = try JSONDecoder().decode([Effect].self, from: data)
                    print("✅ Успешно декодировано эффектов: \(effects.count)")
                    completion(.success(effects))
                } catch {
                    print("❌ Ошибка декодирования: \(error)")
                    completion(.failure(error))
                }
            }
        }
    }

    
    func fetchEffectDetails(id: Int, completion: @escaping (Result<Effect, Error>) -> Void) {
        let request = Request(endpoint: MainScreenEndpoint.getEffectDetails(id: id), method: .get)
        print("➡️ Отправка запроса деталей эффекта: \(request)")
        
        worker.executeRequest(with: request) { response in
            switch response {
            case .failure(let error):
                print("❌ Ошибка сетевого запроса: \(error)")
                completion(.failure(error))
            case .success(let result):
                if let httpResponse = result.response as? HTTPURLResponse {
                    print("⬅️ Статус ответа: \(httpResponse.statusCode)")
                    print("⬅️ Заголовки ответа: \(httpResponse.allHeaderFields)")
                } else {
                    print("⚠️ Нет HTTPURLResponse")
                }
                
                guard let data = result.data else {
                    print("❌ Данные не получены")
                    completion(.failure(Networking.Error.emptyData))
                    return
                }
                
                print("⬅️ Получено сырых данных: \(String(data: data, encoding: .utf8) ?? "nil")")
                
                do {
                    let effect = try JSONDecoder().decode(Effect.self, from: data)
                    print("✅ Успешно декодированы детали эффекта")
                    completion(.success(effect))
                } catch {
                    print("❌ Ошибка декодирования: \(error)")
                    completion(.failure(error))
                }
            }
        }
    }

    func deleteEffect(id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let request = Request(endpoint: MainScreenEndpoint.deleteEffect(id: id), method: .delete)
        print("➡️ Отправка запроса удаления эффекта: \(request)")
        
        worker.executeRequest(with: request) { response in
            switch response {
            case .failure(let error):
                print("❌ Ошибка сетевого запроса: \(error)")
                completion(.failure(error))
            case .success(let result):
                if let httpResponse = result.response as? HTTPURLResponse {
                    print("⬅️ Статус ответа: \(httpResponse.statusCode)")
                }
                completion(.success(()))
            }
        }
    }

    func fetchEffectComments(id: Int, completion: @escaping (Result<[Comment], Error>) -> Void) {
        let request = Request(endpoint: MainScreenEndpoint.getEffectComments(id: id), method: .get)
        print("➡️ Отправка запроса комментариев: \(request)")
        worker.executeRequest(with: request) { response in
            switch response {
            case .failure(let error):
                print("❌ Ошибка сетевого запроса: \(error)")
                completion(.failure(error))
            case .success(let result):
                if let httpResponse = result.response as? HTTPURLResponse {
                    print("⬅️ Статус ответа: \(httpResponse.statusCode)")
                    print("⬅️ Заголовки ответа: \(httpResponse.allHeaderFields)")
                } else {
                    print("⚠️ Нет HTTPURLResponse")
                }
                guard let data = result.data else {
                    print("❌ Данные не получены")
                    completion(.failure(Networking.Error.emptyData))
                    return
                }
                print("⬅️ Получено сырых данных: \(String(data: data, encoding: .utf8) ?? "nil")")
                do {
                    let decoder = JSONDecoder()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    let comments = try decoder.decode([Comment].self, from: data)
                    print("✅ Успешно декодировано комментариев: \(comments.count)")
                    completion(.success(comments))
                } catch {
                    print("❌ Ошибка декодирования: \(error)")
                    completion(.failure(error))
                }
            }
        }
    }

    func postEffectComment(effectId: Int, body: [String: [String: String]], token: String, completion: @escaping (Result<Comment, Error>) -> Void) {
        print("postEffectComment called, body: \(body)")
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            print("Ошибка сериализации JSON для body: \(body)")
            completion(.failure(Networking.Error.invalidRequest))
            return
        }
        let request = Request(endpoint: MainScreenEndpoint.postEffectComment(effectId: effectId, token: token), method: .post, body: jsonData)
        print("➡️ Отправка POST запроса комментария: \(request)")
        worker.executeRequest(with: request) { response in
            switch response {
            case .failure(let error):
                print("❌ Ошибка отправки комментария: \(error)")
                completion(.failure(error))
            case .success(let result):
                if let httpResponse = result.response as? HTTPURLResponse {
                    print("⬅️ Статус ответа на POST комментарий: \(httpResponse.statusCode)")
                }
                guard let data = result.data else {
                    completion(.failure(Networking.Error.emptyData))
                    return
                }
                do {
                    let comment = try JSONDecoder().decode(Comment.self, from: data)
                    print("✅ Комментарий успешно отправлен")
                    completion(.success(comment))
                } catch {
                    print("❌ Ошибка декодирования ответа комментария: \(error)")
                    completion(.failure(error))
                }
            }
        }
    }

    func deleteEffectComment(effectId: Int, commentId: Int, token: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let request = Request(endpoint: MainScreenEndpoint.deleteEffectComment(effectId: effectId, commentId: commentId, token: token), method: .delete)
        print("➡️ Отправка DELETE запроса комментария: \(request)")
        worker.executeRequest(with: request) { response in
            switch response {
            case .failure(let error):
                print("❌ Ошибка удаления комментария: \(error)")
                completion(.failure(error))
            case .success(let result):
                if let httpResponse = result.response as? HTTPURLResponse {
                    print("⬅️ Статус ответа на DELETE комментарий: \(httpResponse.statusCode)")
                }
                completion(.success(()))
            }
        }
    }
}

