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
    let imageName: String
    let backgroundImageName: String
}

struct OnboardingData {
    static let items = [
        OnboardingItem(
            title: "Находи эффекты\nи делись ими",
            imageName: "onboarding1",
            backgroundImageName: "Onb1"
        ),
        OnboardingItem(
            title: "Собирай эффекты\nи референсы в коллекции",
            imageName: "onboarding2",
            backgroundImageName: "Onb2"
        ),
        OnboardingItem(
            title: "Подписывайся\nна чужие коллекции",
            imageName: "onboarding3",
            backgroundImageName: "Onb3"
        ),
        OnboardingItem(
            title: "Настраивай ленту\nпод себя",
            imageName: "onboarding4",
            backgroundImageName: "Onb4"
        )
    ]
}



