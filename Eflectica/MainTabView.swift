//
//  MainTabView.swift
//  Eflectica
//
//  Created by Анна on 20.05.2025.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var searchViewModel = SearchScreenViewModel()
    @StateObject private var collectionsViewModel = CollectionsScreenViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MainScreenView()
                .tabItem {
                    Image(selectedTab == 0 ? "mainIconActive" : "mainIcon")
                }
                .tag(0)
            
            SearchScreenView(viewModel: searchViewModel)
                .tabItem {
                    Image(selectedTab == 1 ? "searchIconActive" : "searchIcon")
                }
                .tag(1)
            
            CollectionsScreenView(viewModel: collectionsViewModel)
                .tabItem {
                    Image(selectedTab == 2 ? "colIectionsIconActive" : "colIectionsIcon")
                }
                .tag(2)
            
            ProfileScreenView()
                .tabItem {
                    Image(selectedTab == 3 ? "profileIconActive" : "profileIcon")
                }
                .tag(3)
        }
        .background(Color("LightGrey"))
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(named: "WhiteColor")
            
            // Убираем стандартную линию
            appearance.shadowImage = UIImage()
            appearance.shadowColor = nil
            
            // Создаем эффект тени
            let tabBarAppearance = UITabBar.appearance()
            tabBarAppearance.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
            tabBarAppearance.layer.shadowOffset = CGSize(width: 0, height: -2)
            tabBarAppearance.layer.shadowRadius = 6
            tabBarAppearance.layer.shadowOpacity = 1
            
            // Применяем внешний вид
            tabBarAppearance.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                tabBarAppearance.scrollEdgeAppearance = appearance
            }
        }
    }
}

