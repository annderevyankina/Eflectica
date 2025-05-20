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
        
        worker.executeRequest(with: request) { response in
        }
    }
}

