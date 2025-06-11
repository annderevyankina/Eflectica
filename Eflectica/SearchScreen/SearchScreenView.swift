//
//  SearchScreenView.swift
//  Eflectica
//
//  Created by Анна on 18.05.2025.
//

import SwiftUI

struct SearchScreenView: View {
    @StateObject var viewModel: SearchScreenViewModel
    
    private let primaryBlue = Color("PrimaryBlue")
    private let textColor = Color("TextColor")
    private let greyColor = Color("Grey")
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                Text("Категории")
                    .font(.custom("BasisGrotesquePro-Medium", size: 32))
                    .foregroundStyle(primaryBlue)
                    .padding(.horizontal)
                    .padding(.top, 16)
                
                // Search Bar
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(greyColor)
                    
                    TextField("Поиск эффектов", text: $viewModel.searchText)
                        .font(.custom("BasisGrotesquePro-Regular", size: 17))
                        .foregroundColor(textColor)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(greyColor, lineWidth: 2)
                        .background(Color.white.cornerRadius(8))
                )
                .padding(.horizontal)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        if viewModel.searchText.isEmpty {
                            // Show all categories when search is empty
                            ForEach(viewModel.categories) { category in
                                CategorySection(
                                    category: category,
                                    effects: viewModel.effectsByCategory[category.id] ?? []
                                )
                            }
                        } else {
                            // Show search results
                            if viewModel.searchResults.isEmpty {
                                Text("Ничего не найдено")
                                    .font(.custom("BasisGrotesquePro-Regular", size: 17))
                                    .foregroundColor(greyColor)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.top, 32)
                            } else {
                                LazyVStack(spacing: 16) {
                                    ForEach(viewModel.searchResults) { effect in
                                        NavigationLink(value: EffectRoute.effectDetail(id: effect.id)) {
                                            EffectCardView(
                                                id: effect.id,
                                                images: [effect.afterImage.url, effect.beforeImage.url],
                                                name: effect.name,
                                                programs: effect.programList,
                                                rating: effect.averageRating,
                                                isTopEffect: false,
                                                isFullWidth: true
                                            )
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .background(Color("LightGrey"))
            .navigationBarHidden(true)
            .navigationDestination(for: EffectRoute.self) { route in
                switch route {
                case .effectDetail(let id):
                    EffectDetailView(viewModel: EffectDetailViewModel(effectId: id))
                }
            }
            .navigationDestination(for: CategoryRoute.self) { route in
                switch route {
                case .category(let category):
                    CategoryView(
                        category: category,
                        effects: viewModel.effectsByCategory[category.id] ?? []
                    )
                }
            }
        }
        .onAppear {
            viewModel.loadEffects()
        }
    }
}

// MARK: - Category Section
struct CategorySection: View {
    let category: Category
    let effects: [Effect]
    
    private let textColor = Color("TextColor")
    private let primaryBlue = Color("PrimaryBlue")
    private let greyColor = Color("Grey")
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(category.name)
                .font(.custom("BasisGrotesquePro-Medium", size: 24))
                .foregroundStyle(textColor)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    // Показываем первые 3 эффекта
                    ForEach(effects.prefix(3)) { effect in
                        NavigationLink(value: EffectRoute.effectDetail(id: effect.id)) {
                            EffectCardView(
                                id: effect.id,
                                images: [effect.afterImage.url, effect.beforeImage.url],
                                name: effect.name,
                                programs: effect.programList,
                                rating: effect.averageRating,
                                isTopEffect: false
                            )
                        }
                    }
                    
                    // Кнопка "Все"
                    if effects.count >= 3 {
                        NavigationLink(value: CategoryRoute.category(category: category)) {
                            VStack(spacing: 8) {
                                Spacer()
                                
                                Image("moreIcon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(primaryBlue)
                                
                                Text("Все")
                                    .font(.custom("BasisGrotesquePro-Medium", size: 17))
                                    .foregroundStyle(primaryBlue)
                                
                                Spacer()
                            }
                            .frame(width: 100, height: 260)
                            .cornerRadius(20)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            print("CategorySection appeared for \(category.name) with \(effects.count) effects")
        }
    }
}

// MARK: - Category Route
enum CategoryRoute: Hashable {
    case category(category: Category)
}

// MARK: - Preview Provider
struct SearchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreenView(viewModel: SearchScreenViewModel())
    }
}

