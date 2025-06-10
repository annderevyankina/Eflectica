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
                                NavigationLink(value: EffectRoute.effectDetail(id: effect.id)) {
                                    EffectCardView(
                                        id: effect.id,
                                        images: [effect.beforeImage.url, effect.afterImage.url],
                                        name: effect.name,
                                        programs: effect.programList,
                                        rating: effect.averageRating,
                                        showRating: true
                                    )
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Text("Новые эффекты")
                        .font(.custom("BasisGrotesquePro-Medium", size: 32))
                        .foregroundColor(Color("PrimaryBlue"))
                        .padding(.horizontal)
                        .padding(.top, 16)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(viewModel.newEffects) { effect in
                                NavigationLink(value: EffectRoute.effectDetail(id: effect.id)) {
                                    EffectCardView(
                                        id: effect.id,
                                        images: [effect.beforeImage.url, effect.afterImage.url],
                                        name: effect.name,
                                        programs: effect.programList,
                                        rating: effect.averageRating,
                                        showRating: true
                                    )
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
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








