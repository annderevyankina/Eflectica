//
//  EffectCardViewModel.swift
//  Eflectica
//
//  Created by Анна on 21.05.2025.
//

import Foundation
import SwiftUI

class EffectCardViewModel: ObservableObject {
    @Published var name: String
    @Published var description: String
    @Published var beforeImageUrl: String
    @Published var afterImageUrl: String
    @Published var averageRating: Double
    @Published var programs: [String]
    @Published var categoryList: [String]
    @Published var tasks: [String]?
    let authorUsername: String
    let authorAvatarUrl: String
    let manual: String?
    
    init(
        name: String,
        description: String,
        beforeImageUrl: String,
        afterImageUrl: String,
        averageRating: Double = 0.0,
        programs: [String],
        categoryList: [String],
        tasks: [String]?,
        authorUsername: String,
        authorAvatarUrl: String,
        manual: String?
    ) {
        self.name = name
        self.description = description
        self.beforeImageUrl = beforeImageUrl
        self.afterImageUrl = afterImageUrl
        self.averageRating = averageRating
        self.programs = programs
        self.categoryList = categoryList
        self.tasks = tasks
        self.authorUsername = authorUsername
        self.authorAvatarUrl = authorAvatarUrl
        self.manual = manual
    }
    
    var formattedRating: String {
        String(format: "%.1f", averageRating)
    }
    
    static func from(effect: Effect) -> EffectCardViewModel {
        EffectCardViewModel(
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
    }
} 
