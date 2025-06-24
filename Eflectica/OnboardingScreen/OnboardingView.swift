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

    private let primaryColor = Color("PrimaryBlue")
    private let greyColor = Color("DarkGrey")

    var body: some View {
        ZStack {
            ZStack {
                Image(viewModel.currentItem.backgroundImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .clipped()
                    .ignoresSafeArea()
            }
            VStack {
                Text(viewModel.currentItem.title)
                    .font(.custom("BasisGrotesquePro-Medium", size: 32))
                    .foregroundColor(primaryColor)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .top)
                    .padding(.top, 100)
                Spacer()
                if viewModel.isLast {
                    Button(action: {
                        completeOnboarding()
                    }) {
                        Text("Начать")
                            .font(.custom("BasisGrotesquePro-Medium", size: 17))
                            .foregroundColor(.white)
                            .padding(.horizontal, 64)
                            .padding(.vertical, 12)
                            .background(primaryColor)
                            .cornerRadius(6)
                    }
                    .padding(.bottom, 60)
                } else {
                    VStack(spacing: 20) {
                        HStack(spacing: 8) {
                            ForEach(viewModel.items.indices, id: \.self) { index in
                                Circle()
                                    .fill(
                                        index == viewModel.currentIndex
                                            ? primaryColor
                                            : greyColor.opacity(0.3)
                                    )
                                    .frame(width: 8, height: 8)
                            }
                        }
                        Button("Пропустить онбординг") {
                            completeOnboarding()
                        }
                        .font(.custom("BasisGrotesquePro-Regular", size: 16))
                        .foregroundColor(greyColor)
                    }
                    .padding(.bottom, 60)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(edges: .bottom)
        }
        .navigationBarBackButtonHidden(true)
        .gesture(
            DragGesture()
                .onEnded { value in
                    // Свайп влево - следующий слайд
                    if value.translation.width < -50, viewModel.currentIndex < viewModel.items.count - 1 {
                        withAnimation { viewModel.currentIndex += 1 }
                    }
                    // Свайп вправо - предыдущий слайд
                    if value.translation.width > 50, viewModel.currentIndex > 0 {
                        withAnimation { viewModel.currentIndex -= 1 }
                    }
                }
        )
        .toolbar(.hidden, for: .tabBar)
    }

    private func completeOnboarding() {
        hasCompletedOnboarding = true
    }
}

