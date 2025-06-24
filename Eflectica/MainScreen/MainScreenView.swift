//
//  MainScreenView.swift
//  Eflectica
//
//  Created by Анна on 09.04.2025.
//

import SwiftUI

// Вспомогательный enum для навигации по id
enum EffectRoute: Hashable {
    case effectDetail(id: Int)
}

struct EffectListView: View {
    let title: String
    let effects: [Effect]
    var body: some View {
        CategoryView(category: Category(id: "custom", name: title), effects: effects)
    }
}

struct MainScreenView: View {
    @StateObject private var viewModel = MainScreenViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var route: EffectRoute?
    @State private var showTopAll = false
    @State private var showFeedAll = false
    @State private var showAuth = false
    
    init() {
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(named: "LightGrey")
            appearance.shadowColor = .clear // убирает полоску
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var body: some View {
        NavigationStack {
            if let error = viewModel.errorMessage {
                VStack {
                    Spacer()
                    Text("Не можем загрузить данные. Проверьте подключение к интернету")
                        .font(.custom("BasisGrotesquePro-Regular", size: 17))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("LightGrey").ignoresSafeArea())
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Топовые эффекты")
                            .font(.custom("BasisGrotesquePro-Medium", size: 32))
                            .foregroundColor(Color("PrimaryBlue"))
                            .padding(.horizontal)
                            .padding(.top, 16)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 6) {
                                ForEach(viewModel.topEffects) { effect in
                                    NavigationLink(value: EffectRoute.effectDetail(id: effect.id)) {
                                        EffectCardView(
                                            id: effect.id,
                                            images: [effect.afterImage?.url ?? "", effect.beforeImage?.url ?? ""],
                                            name: effect.name,
                                            programs: effect.programs?.map { $0.name } ?? [],
                                            rating: effect.averageRating ?? 0,
                                            isTopEffect: true
                                        )
                                    }
                                }
                                Button(action: { showTopAll = true }) {
                                    VStack(spacing: 8) {
                                        Spacer()
                                        Image("moreIcon")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(Color("PrimaryBlue"))
                                        Text("Все")
                                            .font(.custom("BasisGrotesquePro-Medium", size: 17))
                                            .foregroundColor(Color("PrimaryBlue"))
                                        Spacer()
                                    }
                                    .frame(width: 100, height: 260)
                                    .cornerRadius(20)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .background(
                            NavigationLink(destination: EffectListView(title: "Топовые эффекты", effects: viewModel.topEffects), isActive: $showTopAll) { EmptyView() }.hidden()
                        )
                        
                        Text("Лента")
                            .font(.custom("BasisGrotesquePro-Medium", size: 32))
                            .foregroundColor(Color("PrimaryBlue"))
                            .padding(.horizontal)
                            .padding(.top, 16)
                        
                        if authViewModel.isAuthorized {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 6) {
                                    ForEach(viewModel.newEffects.prefix(3)) { effect in
                                        NavigationLink(value: EffectRoute.effectDetail(id: effect.id)) {
                                            EffectCardView(
                                                id: effect.id,
                                                images: [effect.afterImage?.url ?? "", effect.beforeImage?.url ?? ""],
                                                name: effect.name,
                                                programs: effect.programs?.map { $0.name } ?? [],
                                                rating: effect.averageRating ?? 0,
                                                isTopEffect: false
                                            )
                                        }
                                    }
                                    if !viewModel.newEffects.isEmpty {
                                        Button(action: { showFeedAll = true }) {
                                            VStack(spacing: 8) {
                                                Spacer()
                                                Image("moreIcon")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 24, height: 24)
                                                    .foregroundColor(Color("PrimaryBlue"))
                                                Text("Все")
                                                    .font(.custom("BasisGrotesquePro-Medium", size: 17))
                                                    .foregroundColor(Color("PrimaryBlue"))
                                                Spacer()
                                            }
                                            .frame(width: 100, height: 260)
                                            .cornerRadius(20)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .background(
                                NavigationLink(destination: EffectListView(title: "Лента", effects: viewModel.newEffects), isActive: $showFeedAll) { EmptyView() }.hidden()
                            )
                        } else {
                            VStack(spacing: 16) {
                                Text("Чтобы увидеть ленту, нужно войти")
                                    .font(.custom("BasisGrotesquePro-Regular", size: 17))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 24)
                                Button("Войти") {
                                    showAuth = true
                                }
                                .font(.custom("BasisGrotesquePro-Regular", size: 17))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(Color("PrimaryBlue"))
                                .cornerRadius(8)
                                .padding(.horizontal, 40)
                                .sheet(isPresented: $showAuth) {
                                    AuthView(viewModel: authViewModel)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 40)
                }
                .background(Color("LightGrey"))
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Image("bellIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24)
                            .foregroundColor(Color("PrimaryBlue"))
                    }
                }
                .toolbarBackground(Color("LightGrey"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: EffectRoute.self) { route in
                    switch route {
                    case .effectDetail(let id):
                        EffectDetailView(viewModel: EffectDetailViewModel(effectId: id))
                    }
                }
                .onAppear {
                    viewModel.loadEffects()
                }
            }
        }
    }
}








