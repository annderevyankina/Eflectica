//
//  AuthWorker.swift
//  Eflectica
//
//  Created by Анна on 09.04.2025.
//
import SwiftUI

final class AuthWorker {
    let worker = BaseURLWorker(baseUrl: "http://localhost:3000")

    func load(request: Request, completion: @escaping (Result<Data?, Error>) -> Void) {
        worker.executeRequest(with: request) { response in
            switch response {
            case .failure(let error):
                completion(.failure(error))
            case .success(let result):
                completion(.success(result.data))
            }
        }
    }
}
