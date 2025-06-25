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
    @ObservedObject var authViewModel: AuthViewModel
    @Published var effectCard: EffectCardViewModel?
    @Published var isLoading = false
    @Published var error: Error?
    @Published var comments: [CommentCardViewModel] = []
    
    private let worker = MainScreenWorker()
    private let effectId: Int
    
    init(effectId: Int, authViewModel: AuthViewModel) {
        self.effectId = effectId
        self.authViewModel = authViewModel
    }
    
    func fetchEffectDetails() {
        isLoading = true
        error = nil
        print("[EffectDetailViewModel] fetchEffectDetails started for id: \(effectId)")
        worker.fetchEffectDetails(id: effectId) { [weak self] result in
            Task { @MainActor in
                self?.isLoading = false
                switch result {
                case .success(let effect):
                    print("[EffectDetailViewModel] fetchEffectDetails success: \(effect)")
                    self?.effectCard = EffectCardViewModel(
                        name: effect.name,
                        description: effect.description,
                        beforeImageUrl: effect.beforeImage?.url ?? "",
                        afterImageUrl: effect.afterImage?.url ?? "",
                        averageRating: effect.averageRating ?? 0,
                        programs: effect.programs?.map { $0.name } ?? [],
                        categoryList: effect.categories ?? [],
                        tasks: effect.tasks,
                        authorUsername: effect.author?.username ?? "",
                        authorAvatarUrl: effect.author?.avatar.url ?? "",
                        manual: effect.manual
                    )
                    self?.fetchComments()
                case .failure(let error):
                    print("[EffectDetailViewModel] fetchEffectDetails error: \(error)")
                    self?.error = error
                }
            }
        }
    }
    
    func fetchComments() {
        print("[EffectDetailViewModel] fetchComments started for id: \(effectId)")
        worker.fetchEffectComments(id: effectId) { [weak self] result in
            Task { @MainActor in
                switch result {
                case .success(let comments):
                    print("[EffectDetailViewModel] fetchComments success: \(comments.count) комментариев")
                    self?.comments = comments.map { CommentCardViewModel(comment: $0) }
                case .failure(let error):
                    print("[EffectDetailViewModel] fetchComments error: \(error)")
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
