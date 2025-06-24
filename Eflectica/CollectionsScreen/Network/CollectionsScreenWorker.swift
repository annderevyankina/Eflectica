//
//  CollectionsScreenWorker.swift
//  Eflectica
//
//  Created by Анна on 18.05.2025.
//

import Foundation

struct CollectionsResponse: Decodable {
    let collections: [Collection]
    let favorites: [Collection]?
}

struct Subscription: Decodable, Identifiable {
    let id: Int
    let collectionId: Int
    let userId: Int
    // Можно добавить created_at, updated_at если нужно
    enum CodingKeys: String, CodingKey {
        case id
        case collectionId = "collection_id"
        case userId = "user_id"
    }
}

class CollectionsScreenWorker {
    func fetchMyCollections(token: String, completion: @escaping (Result<[Collection], Error>) -> Void) {
        fetchCollections(endpoint: .myCollections, token: token, completion: completion)
    }
    
    func fetchSubCollections(token: String, completion: @escaping (Result<[Collection], Error>) -> Void) {
        fetchSubscriptions(token: token, completion: completion)
    }
    
    func fetchAllCollections(token: String, completion: @escaping (Result<[Collection], Error>) -> Void) {
        fetchCollections(endpoint: .allCollections, token: token, completion: completion)
    }
    
    private func fetchCollections(endpoint: CollectionsScreenEndpoint, token: String, completion: @escaping (Result<[Collection], Error>) -> Void) {
        guard let url = URL(string: "http://localhost:3000" + endpoint.compositePath) else {
            print("[CollectionsWorker] Invalid URL: \(endpoint.compositePath)")
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        endpoint.headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        print("[CollectionsWorker] Requesting: \(url)")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("[CollectionsWorker] Network error: \(error)")
                completion(.failure(error))
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("[CollectionsWorker] HTTP status: \(httpResponse.statusCode)")
            }
            guard let data = data else {
                print("[CollectionsWorker] No data received")
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }
            if let jsonString = String(data: data, encoding: .utf8) {
                print("[CollectionsWorker] Response JSON: \(jsonString)")
            }
            do {
                if endpoint == .allCollections {
                    // Для /api/v1/collections ждем массив
                    let collections = try JSONDecoder().decode([Collection].self, from: data)
                    print("[CollectionsWorker] Decoded collections count: \(collections.count)")
                    completion(.success(collections))
                } else {
                    // Для остальных — объект с ключом collections
                    let response = try JSONDecoder().decode(CollectionsResponse.self, from: data)
                    print("[CollectionsWorker] Decoded collections count: \(response.collections.count)")
                    completion(.success(response.collections))
                }
            } catch {
                print("[CollectionsWorker] Decoding error: \(error)")
                completion(.failure(error))
            }
        }
        task.resume()
    }

    // Для подписок: получаем подписки, затем коллекции по их id
    private func fetchSubscriptions(token: String, completion: @escaping (Result<[Collection], Error>) -> Void) {
        guard let url = URL(string: "http://localhost:3000/api/v1/sub_collections") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print("[CollectionsWorker] Requesting: \(url)")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("[CollectionsWorker] Network error: \(error)")
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }
            do {
                let subscriptions = try JSONDecoder().decode([Subscription].self, from: data)
                print("[CollectionsWorker] Decoded sub_collections count: \(subscriptions.count)")
                let ids = subscriptions.map { $0.collectionId }
                self.fetchCollectionsByIds(ids: ids, token: token, completion: completion)
            } catch {
                print("[CollectionsWorker] Decoding error: \(error)")
                completion(.failure(error))
            }
        }
        task.resume()
    }

    // Получить коллекции по массиву id (можно оптимизировать на сервере)
    func fetchCollectionsByIds(ids: [Int], token: String, completion: @escaping (Result<[Collection], Error>) -> Void) {
        guard !ids.isEmpty else {
            completion(.success([]))
            return
        }
        // Пример: делаем последовательные запросы (можно оптимизировать)
        var collections: [Collection] = []
        let group = DispatchGroup()
        var lastError: Error?
        for id in ids {
            group.enter()
            let urlStr = "http://localhost:3000/api/v1/collections/\(id)"
            guard let url = URL(string: urlStr) else { group.leave(); continue }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            URLSession.shared.dataTask(with: request) { data, response, error in
                defer { group.leave() }
                if let error = error { lastError = error; return }
                guard let data = data else { return }
                do {
                    let collection = try JSONDecoder().decode(Collection.self, from: data)
                    collections.append(collection)
                } catch {
                    lastError = error
                }
            }.resume()
        }
        group.notify(queue: .main) {
            if let error = lastError {
                completion(.failure(error))
            } else {
                completion(.success(collections))
            }
        }
    }
}

