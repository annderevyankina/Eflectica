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
    private let greyColor = Color("Grey")

    var body: some View {
        NavigationStack {
            ZStack {
                GeometryReader { geo in
                    Image(viewModel.currentItem.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                        .overlay(
                            Image(viewModel.currentItem.imageName)
                                .resizable()
                                .frame(width: 1024, height: 102)
                                .scaledToFill()
                                .position(x: geo.size.width / 2, y: geo.size.height / 2)
                                .clipped()
                        )
                        .ignoresSafeArea()
                }

                VStack {
                    // Только title, subtitle убран
                    Text(viewModel.currentItem.title)
                        .font(.custom("BasisGrotesquePro-Medium", size: 32))
                        .foregroundColor(primaryColor)
                        .multilineTextAlignment(.center)
                        .padding(.top, 60)

                    Spacer()

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
                        .padding(.bottom, 20)

                        HStack {
                            Button("Пропустить онбординг") {
                                completeOnboarding()
                            }
                            .font(.custom("BasisGrotesquePro-Regular", size: 16))
                            .foregroundColor(greyColor)

                            Spacer()

                            Button(viewModel.isLast ? "Начать" : "Далее") {
                                if viewModel.isLast {
                                    completeOnboarding()
                                } else {
                                    viewModel.nextSlide()
                                }
                            }
                            .font(.custom("BasisGrotesquePro-Medium", size: 17))
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


