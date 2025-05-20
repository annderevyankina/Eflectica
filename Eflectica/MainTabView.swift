//
//  MainTabView.swift
//  Eflectica
//
//  Created by Анна on 20.05.2025.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var searchViewModel = SearchScreenViewModel()
    @StateObject private var mainScreenViewModel = MainScreenViewModel()
    @StateObject private var collectionsViewModel = CollectionsScreenViewModel()
    @StateObject private var profileViewModel = ProfileScreenViewModel()

    @EnvironmentObject var authViewModel: AuthViewModel
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = true

    @State private var selectedTab = 0 // По умолчанию вкладка Главная

    var body: some View {
        TabView(selection: $selectedTab) {
            // Главная
            MainScreenView()
                .tabItem {
                    Image(selectedTab == 0 ? "mainIconActive" : "mainIcon")
                }
                .tag(0)
            
            // Поиск
            SearchScreenView(viewModel: searchViewModel)
                .tabItem {
                    Image(selectedTab == 1 ? "searchIconActive" : "searchIcon")
                }
                .tag(1)

            // Коллекции
            CollectionsScreenView(viewModel: collectionsViewModel)
                .tabItem {
                    Image(selectedTab == 2 ? "colIectionsIconActive" : "colIectionsIcon")
                }
                .tag(2)

            // Профиль
            ProfileScreenView()
                .tabItem {
                    Image(selectedTab == 3 ? "profileIconActive" : "profileIcon")
                }
                .tag(3)
        }
    }
}

