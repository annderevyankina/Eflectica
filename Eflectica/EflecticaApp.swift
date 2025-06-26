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
    
    init() {
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }

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
    @State private var isShowingSplash = true

    var body: some View {
        Group {
            if isShowingSplash {
                SplashScreenView(isShowingSplash: $isShowingSplash)
                    .environmentObject(authViewModel)
            } else {
                ContentView()
                    .environmentObject(authViewModel)
            }
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        if !authViewModel.hasCompletedOnboarding {
            OnboardingScreenView()
        } else {
            MainTabView()
        }
    }
}




