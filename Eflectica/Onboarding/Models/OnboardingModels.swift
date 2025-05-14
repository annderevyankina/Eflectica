//
//  OnboardingModels.swift
//  Eflectica
//
//  Created by Анна on 10.05.2025.
//
import Foundation

struct OnboardingItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let imageName: String
}

struct OnboardingData {
    static let items = [
        OnboardingItem(
            title: "Находи эффекты",
            subtitle: "и делись ими",
            imageName: "onboarding1"
        ),
        OnboardingItem(
            title: "Собирай эффекты",
            subtitle: "и референсы в коллекции",
            imageName: "onboarding2"
        ),
        OnboardingItem(
            title: "Подписывайся",
            subtitle: "на чужие коллекции",
            imageName: "onboarding3"
        ),
        OnboardingItem(
            title: "Настраивай ленту",
            subtitle: "под себя",
            imageName: "onboarding4"
        )
    ]
}

