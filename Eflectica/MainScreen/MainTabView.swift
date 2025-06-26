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
    @StateObject private var profileViewModel = ProfileScreenViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                MainScreenView()
            }
            .environmentObject(profileViewModel)
            .environmentObject(collectionsViewModel)
            .tabItem {
                Image(selectedTab == 0 ? "mainIconActive" : "mainIcon")
            }
            .tag(0)
            
            NavigationView {
                SearchScreenView(viewModel: searchViewModel)
            }
            .environmentObject(profileViewModel)
            .tabItem {
                Image(selectedTab == 1 ? "searchIconActive" : "searchIcon")
            }
            .tag(1)
            
            NavigationView {
                CollectionsScreenView(viewModel: collectionsViewModel)
            }
            .environmentObject(profileViewModel)
            .tabItem {
                Image(selectedTab == 2 ? "colIectionsIconActive" : "colIectionsIcon")
            }
            .tag(2)
            
            NavigationView {
                ProfileScreenView()
            }
            .environmentObject(profileViewModel)
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
            
            appearance.shadowImage = UIImage()
            appearance.shadowColor = nil
            
            let tabBarAppearance = UITabBar.appearance()
            tabBarAppearance.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
            tabBarAppearance.layer.shadowOffset = CGSize(width: 0, height: -2)
            tabBarAppearance.layer.shadowRadius = 6
            tabBarAppearance.layer.shadowOpacity = 1
            
            tabBarAppearance.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                tabBarAppearance.scrollEdgeAppearance = appearance
            }
        }
    }
}

