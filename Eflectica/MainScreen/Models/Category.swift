//
//  Category.swift
//  Eflectica
//
//  Created by Анна on 20.05.2025.
//

import Foundation

struct Category: Identifiable, Hashable {
    let id: String
    let name: String 
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Category, rhs: Category) -> Bool {
        lhs.id == rhs.id
    }
}

let categoryDescriptions: [String: String] = [
    "photoProcessing": "Обработка фото",
    "3dGrafics": "3D-графика",
    "motion": "Моушен",
    "illustration": "Иллюстрация",
    "animation": "Анимация",
    "uiux": "UI/UX-анимация",
    "videoProcessing": "Обработка видео",
    "vfx": "VFX",
    "gamedev": "Геймдев",
    "arvr": "AR & VR"
] 
