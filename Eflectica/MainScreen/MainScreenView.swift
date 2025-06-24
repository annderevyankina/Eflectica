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

// Добавляю enum SortType
fileprivate enum SortType {
    case newest
    case popular
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
    @State private var showTopFilter = false
    @State private var showFeedFilter = false
    @State private var filteredTopEffects: [Effect]? = nil
    @State private var filteredFeedEffects: [Effect]? = nil
    @State private var sortTypeTop: SortType = .newest
    @State private var sortTypeFeed: SortType = .newest
    @State private var showTopSortMenu = false
    @State private var showFeedSortMenu = false
    
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
    
    private var errorView: some View {
        VStack {
            Spacer()
            Text("Не можем загрузить данные. Проверьте подключение к интернету")
                .font(.custom("BasisGrotesquePro-Regular", size: 17))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            Button("Повторить") {
                viewModel.loadEffects()
            }
            .font(.custom("BasisGrotesquePro-Medium", size: 17))
            .foregroundColor(.white)
            .frame(height: 48)
            .frame(maxWidth: 220)
            .background(Color("PrimaryBlue"))
            .cornerRadius(8)
            .padding(.top, 16)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("LightGrey").ignoresSafeArea())
    }
    
    private var topEffectsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 12) {
                Text("Топовые эффекты")
                    .font(.custom("BasisGrotesquePro-Medium", size: 32))
                    .foregroundColor(Color("PrimaryBlue"))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
            .padding(.top, 16)
            .padding(.bottom, 8)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(filteredTopEffects ?? viewModel.topEffects) { effect in
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
            if showTopSortMenu {
                VStack(alignment: .leading, spacing: 0) {
                    Button(action: {
                        sortTypeTop = .newest
                        showTopSortMenu = false
                        sortTopEffects()
                    }) {
                        Text("Сначала новые")
                            .font(.custom("BasisGrotesquePro-Medium", size: 16))
                            .foregroundColor(sortTypeTop == .newest ? Color("PrimaryBlue") : Color("TextColor"))
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Divider()
                    Button(action: {
                        sortTypeTop = .popular
                        showTopSortMenu = false
                        sortTopEffects()
                    }) {
                        Text("Сначала популярные")
                            .font(.custom("BasisGrotesquePro-Medium", size: 16))
                            .foregroundColor(sortTypeTop == .popular ? Color("PrimaryBlue") : Color("TextColor"))
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white).shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4))
                .frame(width: 200)
                .padding(.leading, 16)
                .padding(.top, 0)
            }
        }
    }

    private var feedSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 12) {
                Text("Лента")
                    .font(.custom("BasisGrotesquePro-Medium", size: 32))
                    .foregroundColor(Color("PrimaryBlue"))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
            .padding(.top, 16)
            .padding(.bottom, 8)
            if authViewModel.isAuthorized {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(filteredFeedEffects ?? Array(viewModel.newEffects.prefix(3))) { effect in
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
            if showFeedSortMenu {
                VStack(alignment: .leading, spacing: 0) {
                    Button(action: {
                        sortTypeFeed = .newest
                        showFeedSortMenu = false
                        sortFeedEffects()
                    }) {
                        Text("Сначала новые")
                            .font(.custom("BasisGrotesquePro-Medium", size: 16))
                            .foregroundColor(sortTypeFeed == .newest ? Color("PrimaryBlue") : Color("TextColor"))
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Divider()
                    Button(action: {
                        sortTypeFeed = .popular
                        showFeedSortMenu = false
                        sortFeedEffects()
                    }) {
                        Text("Сначала популярные")
                            .font(.custom("BasisGrotesquePro-Medium", size: 16))
                            .foregroundColor(sortTypeFeed == .popular ? Color("PrimaryBlue") : Color("TextColor"))
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white).shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4))
                .frame(width: 200)
                .padding(.leading, 16)
                .padding(.top, 0)
            }
        }
    }

    var body: some View {
        NavigationStack {
            if let _ = viewModel.errorMessage {
                errorView
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        topEffectsSection
                        feedSection
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
    
    private func sortTopEffects() {
        if let effects = filteredTopEffects {
            switch sortTypeTop {
            case .newest:
                filteredTopEffects = effects.sorted { lhs, rhs in
                    (date(from: lhs.createdAt) ?? .distantPast) > (date(from: rhs.createdAt) ?? .distantPast)
                }
            case .popular:
                filteredTopEffects = effects.sorted { ($0.averageRating ?? 0) > ($1.averageRating ?? 0) }
            }
        }
    }
    
    private func sortFeedEffects() {
        if let effects = filteredFeedEffects {
            switch sortTypeFeed {
            case .newest:
                filteredFeedEffects = effects.sorted { lhs, rhs in
                    (date(from: lhs.createdAt) ?? .distantPast) > (date(from: rhs.createdAt) ?? .distantPast)
                }
            case .popular:
                filteredFeedEffects = effects.sorted { ($0.averageRating ?? 0) > ($1.averageRating ?? 0) }
            }
        }
    }
    
    private func date(from string: String?) -> Date? {
        guard let string = string else { return nil }
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: string)
    }
}








