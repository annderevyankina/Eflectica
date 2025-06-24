//
//  EffectDetailViewModel.swift
//  Eflectica
//
//  Created by Анна on 21.05.2025.
//

import Foundation
import SwiftUI

@MainActor
class EffectDetailViewModel: ObservableObject {
    @Published var effectCard: EffectCardViewModel?
    @Published var isLoading = false
    @Published var error: Error?
    @Published var comments: [CommentCardViewModel] = []
    
    private let worker = MainScreenWorker()
    private let effectId: Int
    
    init(effectId: Int) {
        self.effectId = effectId
    }
    
    func fetchEffectDetails() {
        isLoading = true
        error = nil
        
        worker.fetchEffectDetails(id: effectId) { [weak self] result in
            Task { @MainActor in
                self?.isLoading = false
                
                switch result {
                case .success(let effect):
                    self?.effectCard = EffectCardViewModel(
                        name: effect.name,
                        description: effect.description,
                        beforeImageUrl: effect.beforeImage?.url ?? "",
                        afterImageUrl: effect.afterImage?.url ?? "",
                        averageRating: effect.averageRating ?? 0,
                        programs: effect.programs?.map { $0.name } ?? [],
                        categoryList: effect.categories ?? []
                    )
                case .failure(let error):
                    self?.error = error
                }
            }
        }
    }
    
    func loadMoreComments() {
        // TODO: Реализовать подгрузку комментариев с сервера
    }
}

struct EffectCommentViewModel: Identifiable {
    let id: Int
    let username: String
    let avatarUrl: String
    let text: String
    let dateString: String
} 
