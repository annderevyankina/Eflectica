import Foundation
import SwiftUI

@MainActor
class EffectDetailViewModel: ObservableObject {
    @Published var effectCard: EffectCardViewModel?
    @Published var isLoading = false
    @Published var error: Error?
    
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
                        beforeImageUrl: effect.beforeImage.url,
                        afterImageUrl: effect.afterImage.url,
                        averageRating: effect.averageRating,
                        programs: effect.programList,
                        categoryList: effect.categoryList
                    )
                case .failure(let error):
                    self?.error = error
                }
            }
        }
    }
} 