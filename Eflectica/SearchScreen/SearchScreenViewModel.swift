//
//  SearchScreenViewModel.swift
//  Eflectica
//
//  Created by Анна on 18.05.2025.
//

import SwiftUI
import Foundation
import Combine

class SearchScreenViewModel: ObservableObject {
    
    @Published var categories: [Category] = [
        Category(id: "photoProcessing", name: "Обработка фото"),
        Category(id: "3dGrafics", name: "3D-графика"),
        Category(id: "motion", name: "Моушен"),
        Category(id: "illustration", name: "Иллюстрация"),
        Category(id: "animation", name: "Анимация"),
        Category(id: "uiux", name: "UI/UX-анимация"),
        Category(id: "videoProcessing", name: "Обработка видео"),
        Category(id: "vfx", name: "VFX"),
        Category(id: "gamedev", name: "Геймдев"),
        Category(id: "arvr", name: "AR & VR")
    ]
    
    @Published var effectsByCategory: [String: [Effect]] = [:]
    @Published var searchText: String = ""
    @Published var searchResults: [Effect] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let worker = MainScreenWorker()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSearchSubscription()
    }
    
    private func setupSearchSubscription() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                self?.performSearch(searchText)
            }
            .store(in: &cancellables)
    }
    
    private func performSearch(_ query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        let lowercasedQuery = query.lowercased()
        var results: [Effect] = []
        
        for effects in effectsByCategory.values {
            let matchingEffects = effects.filter { effect in
                if effect.name.lowercased().contains(lowercasedQuery) {
                    return true
                }
                
                if effect.description.lowercased().contains(lowercasedQuery) {
                    return true
                }
                
                if (effect.programs?.map { $0.name } ?? []).contains(where: { $0.lowercased().contains(lowercasedQuery) }) {
                    return true
                }
                
                if (effect.categories ?? []).contains(where: { $0.lowercased().contains(lowercasedQuery) }) {
                    return true
                }
                
                return false
            }
            results.append(contentsOf: matchingEffects)
        }
        
        searchResults = Array(Set(results)).sorted(by: { ($0.averageRating ?? 0) > ($1.averageRating ?? 0) })
    }
    
    
    func loadEffects() {
        isLoading = true
        error = nil
        
        worker.fetchAllEffects { [weak self] result in
            Task { @MainActor in
                self?.isLoading = false
                
                switch result {
                case .success(let effects):
                    var groupedEffects: [String: [Effect]] = [:]
                    
                    self?.categories.forEach { category in
                        groupedEffects[category.id] = []
                    }
                    
                    for effect in effects {
                        for category in effect.categories ?? [] {
                            if let _ = groupedEffects[category] {
                                groupedEffects[category]?.append(effect)
                            }
                        }
                    }
                    
                    self?.effectsByCategory = groupedEffects
                    
                case .failure(let error):
                    self?.error = error
                }
            }
        }
    }
}
