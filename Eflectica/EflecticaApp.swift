//  EflecticaApp.swift
//  Eflectica
//
//  Created by Анна on 09.04.2025.
//

import SwiftUI

@main
struct EflecticaApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    var body: some Scene {
        WindowGroup {
            Group {
                if !isLoggedIn {
                    AuthView(viewModel: AuthViewModel())
                } else if !hasCompletedOnboarding {
                    OnboardingView()
                } else {
                    MainScreenView(viewModel: MainScreenViewModel())
                }
            }
        }
    }
}
