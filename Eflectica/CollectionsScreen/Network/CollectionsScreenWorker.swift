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

    // --- CRUD методы для коллекции ---
    func createCollection(token: String, body: [String: Any], completion: @escaping (Result<Collection, Error>) -> Void) {
        guard let url = URL(string: "http://localhost:3000" + CollectionsScreenEndpoint.createCollection.compositePath) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error { completion(.failure(error)); return }
            guard let data = data else { completion(.failure(NSError(domain: "No data", code: 0))); return }
            do {
                let collection = try JSONDecoder().decode(Collection.self, from: data)
                completion(.success(collection))
            } catch { completion(.failure(error)) }
        }.resume()
    }
    func updateCollection(token: String, id: Int, body: [String: Any], completion: @escaping (Result<Collection, Error>) -> Void) {
        guard let url = URL(string: "http://localhost:3000" + CollectionsScreenEndpoint.updateCollection(id: id).compositePath) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error { completion(.failure(error)); return }
            guard let data = data else { completion(.failure(NSError(domain: "No data", code: 0))); return }
            do {
                let collection = try JSONDecoder().decode(Collection.self, from: data)
                completion(.success(collection))
            } catch { completion(.failure(error)) }
        }.resume()
    }
    func deleteCollection(token: String, id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "http://localhost:3000" + CollectionsScreenEndpoint.deleteCollection(id: id).compositePath) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error { completion(.failure(error)); return }
            completion(.success(()))
        }.resume()
    }
    // --- Эффекты ---
    func addEffect(token: String, collectionId: Int, effectId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "http://localhost:3000" + CollectionsScreenEndpoint.addEffect(collectionId: collectionId, effectId: effectId).compositePath) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error { completion(.failure(error)); return }
            completion(.success(()))
        }.resume()
    }
    func deleteEffect(token: String, collectionId: Int, effectId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "http://localhost:3000" + CollectionsScreenEndpoint.deleteEffect(collectionId: collectionId, effectId: effectId).compositePath) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error { completion(.failure(error)); return }
            completion(.success(()))
        }.resume()
    }
    // --- Ссылки ---
    func addLink(token: String, collectionId: Int, path: String, title: String?, description: String?, completion: @escaping (Result<CollectionLink, Error>) -> Void) {
        let body: [String: Any] = [
            "path": path,
            "title": title ?? "",
            "description": description ?? ""
        ]
        guard let url = URL(string: "http://localhost:3000" + CollectionsScreenEndpoint.addLink(collectionId: collectionId).compositePath) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error { completion(.failure(error)); return }
            guard let data = data else { completion(.failure(NSError(domain: "No data", code: 0))); return }
            do {
                let link = try JSONDecoder().decode(CollectionLink.self, from: data)
                completion(.success(link))
            } catch { completion(.failure(error)) }
        }.resume()
    }
    func updateLink(token: String, collectionId: Int, linkId: Int, path: String, title: String?, description: String?, completion: @escaping (Result<CollectionLink, Error>) -> Void) {
        let body: [String: Any] = [
            "path": path,
            "title": title ?? "",
            "description": description ?? ""
        ]
        guard let url = URL(string: "http://localhost:3000" + CollectionsScreenEndpoint.updateLink(collectionId: collectionId, linkId: linkId).compositePath) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error { completion(.failure(error)); return }
            guard let data = data else { completion(.failure(NSError(domain: "No data", code: 0))); return }
            do {
                let link = try JSONDecoder().decode(CollectionLink.self, from: data)
                completion(.success(link))
            } catch { completion(.failure(error)) }
        }.resume()
    }
    func deleteLink(token: String, collectionId: Int, linkId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "http://localhost:3000" + CollectionsScreenEndpoint.deleteLink(collectionId: collectionId, linkId: linkId).compositePath) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error { completion(.failure(error)); return }
            completion(.success(()))
        }.resume()
    }
    // --- Изображения ---
    func addImage(token: String, collectionId: Int, file: String, title: String?, description: String?, completion: @escaping (Result<CollectionImage, Error>) -> Void) {
        let body: [String: Any] = [
            "file": file,
            "title": title ?? "",
            "description": description ?? ""
        ]
        guard let url = URL(string: "http://localhost:3000" + CollectionsScreenEndpoint.addImage(collectionId: collectionId).compositePath) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error { completion(.failure(error)); return }
            guard let data = data else { completion(.failure(NSError(domain: "No data", code: 0))); return }
            do {
                let image = try JSONDecoder().decode(CollectionImage.self, from: data)
                completion(.success(image))
            } catch { completion(.failure(error)) }
        }.resume()
    }
    func updateImage(token: String, collectionId: Int, imageId: Int, file: String, title: String?, description: String?, completion: @escaping (Result<CollectionImage, Error>) -> Void) {
        let body: [String: Any] = [
            "file": file,
            "title": title ?? "",
            "description": description ?? ""
        ]
        guard let url = URL(string: "http://localhost:3000" + CollectionsScreenEndpoint.updateImage(collectionId: collectionId, imageId: imageId).compositePath) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error { completion(.failure(error)); return }
            guard let data = data else { completion(.failure(NSError(domain: "No data", code: 0))); return }
            do {
                let image = try JSONDecoder().decode(CollectionImage.self, from: data)
                completion(.success(image))
            } catch { completion(.failure(error)) }
        }.resume()
    }
    func deleteImage(token: String, collectionId: Int, imageId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "http://localhost:3000" + CollectionsScreenEndpoint.deleteImage(collectionId: collectionId, imageId: imageId).compositePath) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error { completion(.failure(error)); return }
            completion(.success(()))
        }.resume()
    }
}

