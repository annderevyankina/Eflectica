//
//  MainScreenViewModel.swift
//  Eflectica
//
//  Created by Анна on 09.04.2025.
//

import Foundation
import Combine

class MainScreenViewModel: ObservableObject {
    private let worker = MainScreenWorker()
    
    @Published var topEffects: [Effect] = []
    @Published var newEffects: [Effect] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init() {
        loadEffects()
    }
    
    func loadEffects() {
        isLoading = true
        errorMessage = nil
        
        worker.fetchAllEffects { [weak self] result in
            Task { @MainActor in
                self?.isLoading = false
                
                switch result {
                case .success(let effects):
                    print("Получено эффектов: \(effects.count)")
                    // Отбор топовых эффектов по рейтингу
                    self?.topEffects = self?.filterTopEffects(effects) ?? []
                    
                    // Отбор новых эффектов
                    self?.newEffects = self?.filterNewEffects(effects) ?? []
                    
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // Фильтрация топовых эффектов по рейтингу
    private func filterTopEffects(_ effects: [Effect]) -> [Effect] {
        return effects
            .filter { ($0.averageRating ?? 0) >= 4.0 }
            .sorted(by: { ($0.averageRating ?? 0) > ($1.averageRating ?? 0) })
            .prefix(5)
            .map { $0 }
    }
    
    // Фильтрация новых эффектов
    private func filterNewEffects(_ effects: [Effect]) -> [Effect] {
        let topEffectIds = Set(topEffects.map { $0.id })
        let remainingEffects = effects.filter { !topEffectIds.contains($0.id) }
        return Array(remainingEffects.prefix(10))
    }
}


