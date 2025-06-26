//
//  EffectDetailViewModel.swift
//  Eflectica
//
//  Created by Анна on 21.05.2025.
//

import Foundation
import SwiftUI
import Eflectica

@MainActor
class EffectDetailViewModel: ObservableObject {
    @Published var effectCard: EffectCardViewModel?
    @Published var isLoading = false
    @Published var error: Error?
    @Published var comments: [CommentCardViewModel] = []
    @Published var showDeleteAlert = false
    private var commentToDelete: CommentCardViewModel?
    
    private let worker = MainScreenWorker()
    let effectId: Int
    private var allEffects: [Effect] = []
    private let currentUsername: String?
    private let token: String?
    
    init(effectId: Int, currentUsername: String?, token: String?) {
        self.effectId = effectId
        self.currentUsername = currentUsername
        self.token = token
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
    
    func fetchAllEffects(completion: (() -> Void)? = nil) {
        worker.fetchAllEffects { [weak self] result in
            Task { @MainActor in
                switch result {
                case .success(let effects):
                    self?.allEffects = effects
                case .failure:
                    self?.allEffects = []
                }
                completion?()
            }
        }
    }
    
    func effectsForCategory(_ categoryId: String) -> [Effect] {
        allEffects.filter { $0.categories?.contains(categoryId) == true }
    }
    
    func fetchComments() {
        print("[EffectDetailViewModel] fetchComments вызван")
        print("[EffectDetailViewModel] fetchComments started for id: \(effectId)")
        worker.fetchEffectComments(id: effectId) { [weak self] result in
            Task { @MainActor in
                switch result {
                case .success(let comments):
                    print("[EffectDetailViewModel] fetchComments success: \(comments.count) комментариев")
                    let sorted = comments.sorted { ($0.createdAt ?? .distantPast) > ($1.createdAt ?? .distantPast) }
                    self?.comments = sorted.map { CommentCardViewModel(comment: $0, currentUsername: self?.currentUsername) }
                case .failure(let error):
                    print("[EffectDetailViewModel] fetchComments error: \(error)")
                }
            }
        }
    }
    
    func postComment(text: String, completion: @escaping (Bool) -> Void) {
        print("postComment called with text: \(text)")
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { completion(false); return }
        guard let token = token else {
            print("❌ Токен отсутствует для отправки комментария")
            completion(false)
            return
        }
        let body: [String: [String: String]] = ["comment": ["body": text]]
        worker.postEffectComment(effectId: effectId, body: body, token: token) { [weak self] result in
            Task { @MainActor in
                switch result {
                case .success:
                    self?.fetchComments()
                    completion(true)
                case .failure(let error):
                    print("❌ Ошибка отправки комментария: \(error)")
                    completion(false)
                }
            }
        }
    }
    
    func confirmDeleteComment(comment: CommentCardViewModel) {
        commentToDelete = comment
        showDeleteAlert = true
    }
    
    func deleteComment() {
        guard let comment = commentToDelete else { return }
        guard let token = token else {
            print("❌ Токен отсутствует для удаления комментария")
            return
        }
        worker.deleteEffectComment(effectId: effectId, commentId: comment.id, token: token) { [weak self] result in
            Task { @MainActor in
                switch result {
                case .success:
                    self?.comments.removeAll { $0.id == comment.id }
                case .failure(let error):
                    print("❌ Ошибка удаления комментария: \(error)")
                }
                self?.showDeleteAlert = false
                self?.commentToDelete = nil
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
    let isMine: Bool
    init(comment: Comment, isMine: Bool) {
        self.id = comment.id ?? 0
        self.username = comment.user?.username ?? ""
        self.avatarUrl = comment.user?.avatar?.url ?? ""
        self.text = comment.body ?? ""
        self.dateString = "" // Можно добавить форматирование даты
        self.isMine = isMine
    }
    init(comment: Comment) {
        self.init(comment: comment, isMine: false)
    }
} 
