//  EflecticaApp.swift
//  Eflectica
//
//  Created by Анна on 09.04.2025.
//

import SwiftUI

@main
struct EflecticaApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authViewModel)
        }
    }
}

struct RootView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        if !hasCompletedOnboarding {
            OnboardingView()
                .environmentObject(authViewModel)
        } else if authViewModel.isAuthorized {
            MainTabView()
                .environmentObject(authViewModel)
        } else {
            AuthView(viewModel: authViewModel)
                .environmentObject(authViewModel)
        }
    }
}




