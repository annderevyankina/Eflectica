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
    @Published var feedEffects: [Effect] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func loadEffects() {
        isLoading = true
        errorMessage = nil
        
        worker.fetchAllEffects { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let effects):
                    print("Получено эффектов: \(effects.count)")
                    // Отбор топовых эффектов только по рейтингу
                    self?.topEffects = self?.filterTopEffects(effects) ?? []
                    
                    // Для ленты случайные эффекты (временное решение)
                    self?.feedEffects = self?.randomizeFeedEffects(effects) ?? []
                    
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    
    // Фильтрация топовых эффектов только по рейтингу
    private func filterTopEffects(_ effects: [Effect]) -> [Effect] {
        return effects
            .filter { Double($0.averageRating) >= 4.0 }
            .sorted(by: { $0.averageRating > $1.averageRating })
            .prefix(5)
            .map { $0 }
    }
    
    // Получение случайных эффектов для ленты
    private func randomizeFeedEffects(_ effects: [Effect]) -> [Effect] {
        let topEffectIds = Set(topEffects.map { $0.id })
        let remainingEffects = effects.filter { !topEffectIds.contains($0.id) }
        return Array(remainingEffects.shuffled().prefix(10))
    }
}


