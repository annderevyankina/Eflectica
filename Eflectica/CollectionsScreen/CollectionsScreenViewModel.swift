//
//  CollectionsScreenViewModel.swift
//  Eflectica
//
//  Created by Анна on 18.05.2025.
//

import SwiftUI
import Combine

class CollectionsScreenViewModel: ObservableObject {
    @Published var myCollections: [Collection] = []
    @Published var subCollections: [Collection] = []
    @Published var allCollections: [Collection] = []
    @Published var favorites: [Collection] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    let worker = CollectionsScreenWorker()
    
    // MARK: - Фильтрация топовых коллекций (чужие)
    var topCollections: [Collection] {
        let myIds = Set(myCollections.map { $0.id })
        let subIds = Set(subCollections.map { $0.id })
        return allCollections.filter { !myIds.contains($0.id) && !subIds.contains($0.id) }
    }
    
    // MARK: - Поиск по названию среди всех типов коллекций
    func searchCollections(_ text: String, in collections: [Collection]) -> [Collection] {
        guard !text.isEmpty else { return collections }
        return collections.filter { $0.name.lowercased().contains(text.lowercased()) }
    }
    
    var filteredTopCollections: [Collection] {
        searchCollections(searchText, in: topCollections)
    }
    var filteredMyCollections: [Collection] {
        searchCollections(searchText, in: myCollections)
    }
    var filteredSubCollections: [Collection] {
        searchCollections(searchText, in: subCollections)
    }
    
    @Published var searchText: String = ""
    
    func loadMyCollections(token: String) {
        isLoading = true
        errorMessage = nil
        worker.fetchMyCollections(token: token) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let collections):
                    self?.myCollections = collections
                    if self?.favorites.isEmpty ?? true {
                        let favoritesCollection = Collection(
                            id: -1,
                            name: "Избранное",
                            description: "Ваши избранные эффекты",
                            userId: nil,
                            status: nil,
                            effects: [],
                            links: nil,
                            images: nil
                        )
                        self?.favorites = [favoritesCollection]
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func loadSubCollections(token: String) {
        isLoading = true
        errorMessage = nil
        worker.fetchSubCollections(token: token) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let collections):
                    self?.subCollections = collections
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func loadAllCollections(token: String) {
        isLoading = true
        errorMessage = nil
        worker.fetchAllCollections(token: token) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let collections):
                    self?.allCollections = collections
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
