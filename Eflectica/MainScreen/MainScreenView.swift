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

struct MainScreenView: View {
    @StateObject private var viewModel = MainScreenViewModel()
    @State private var route: EffectRoute?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Топовые эффекты")
                        .font(.custom("BasisGrotesquePro-Medium", size: 32))
                        .foregroundColor(Color("PrimaryBlue"))
                        .padding(.horizontal)
                        .padding(.top, 16)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(viewModel.topEffects) { effect in
                                Button {
                                    route = .effectDetail(id: effect.id)
                                } label: {
                                    EffectCardView(
                                        images: [effect.beforeImage.url, effect.afterImage.url],
                                        title: effect.name,
                                        tags: effect.programs.components(separatedBy: ","),
                                        rating: effect.averageRating,
                                        showRating: true
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }

                    Text("Лента")
                        .font(.custom("BasisGrotesquePro-Medium", size: 32))
                        .foregroundColor(Color("PrimaryBlue"))
                        .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(viewModel.feedEffects) { effect in
                                Button {
                                    route = .effectDetail(id: effect.id)
                                } label: {
                                    EffectCardView(
                                        images: [effect.beforeImage.url, effect.afterImage.url],
                                        title: effect.name,
                                        tags: effect.programs.components(separatedBy: ","),
                                        rating: effect.averageRating,
                                        showRating: false
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .background(Color(.systemBackground))
            .onAppear {
                viewModel.loadEffects()
            }
            .navigationDestination(item: $route) { route in
                switch route {
                case .effectDetail(let id):
                    // Ищем эффект по id среди всех эффектов
                    if let effect = (viewModel.topEffects + viewModel.feedEffects).first(where: { $0.id == id }) {
                        EffectDetailView(effect: effect)
                    } else {
                        Text("Эффект не найден")
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
}








