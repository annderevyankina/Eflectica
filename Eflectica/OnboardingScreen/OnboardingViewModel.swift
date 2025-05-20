//
//  OnboardingViewModel.swift
//  Eflectica
//
//  Created by Анна on 10.05.2025.
//

import SwiftUI

final class OnboardingViewModel: ObservableObject {
    @Published var items: [OnboardingItem] = OnboardingData.items
    
    @Published var currentIndex: Int = 0
    
    var isLast: Bool {
        currentIndex == items.count - 1
    }
    
    func nextSlide() {
        if currentIndex < items.count - 1 {
            currentIndex += 1
        }
    }
    
    var currentItem: OnboardingItem {
        items[currentIndex]
    }
}
