//
//  OnboardingView.swift
//  Eflectica
//
//  Created by Анна on 10.05.2025.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    // Цвет из Assets.xcassets → "PrimaryBlue"
    private let primaryColor = Color("PrimaryBlue")
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Фон
                Image("auth_background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    // Заголовок и подзаголовок
                    VStack(spacing: 8) {
                        Text(viewModel.currentItem.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(primaryColor)
                        
                        Text(viewModel.currentItem.subtitle)
                            .font(.title2)
                            .foregroundColor(primaryColor)
                    }
                    .padding(.top, 60)
                    
                    Spacer()
                    
                    // Изображение слайда
                    Image(viewModel.currentItem.imageName)
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 30)
                    
                    Spacer()
                    
                    // Индикатор и кнопки
                    VStack(spacing: 20) {
                        // Точечный индикатор
                        HStack(spacing: 8) {
                            ForEach(viewModel.items.indices, id: \.self) { index in
                                Circle()
                                    .fill(
                                        index == viewModel.currentIndex
                                            ? primaryColor
                                            : Color.gray.opacity(0.5)
                                    )
                                    .frame(width: 8, height: 8)
                            }
                        }
                        .padding(.bottom, 20)
                        
                        // Кнопки Пропустить / Далее-Начать
                        HStack {
                            Button("Пропустить онбординг") {
                                completeOnboarding()
                            }
                            .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Button(viewModel.isLast ? "Начать" : "Далее") {
                                if viewModel.isLast {
                                    completeOnboarding()
                                } else {
                                    viewModel.nextSlide()
                                }
                            }
                            .padding(.horizontal, 30)
                            .padding(.vertical, 12)
                            .background(primaryColor)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 40)
                    }
                }
                
                NavigationLink(
                    destination: MainScreenView(viewModel: MainScreenViewModel()),
                    isActive: $hasCompletedOnboarding
                ) {
                    EmptyView()
                }
                .hidden()
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    private func completeOnboarding() {
        hasCompletedOnboarding = true
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
