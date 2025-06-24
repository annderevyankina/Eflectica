//
//  ProfileScreenView.swift
//  Eflectica
//
//  Created by Анна on 20.05.2025.
//

import SwiftUI

struct ProfileScreenView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @StateObject private var viewModel = ProfileScreenViewModel()
    @State private var showAuth = false
    @State private var showEditProfileAlert = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color(.systemGray6).ignoresSafeArea()
                if !authViewModel.isAuthorized || (viewModel.user == nil && !viewModel.isLoading) {
                    VStack {
                        Spacer()
                        Text("Не можем загрузить данные. Проверьте подключение к интернету")
                            .font(.custom("BasisGrotesquePro-Regular", size: 17))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    VStack {
                        ZStack(alignment: .topTrailing) {
                            Group {
                                if viewModel.isLoading {
                                    ProgressView()
                                        .padding(.top, 100)
                                } else if let user = viewModel.user {
                                    let isEmptyProfile = (user.username?.isEmpty ?? true) && (user.bio?.isEmpty ?? true) && (user.contact?.isEmpty ?? true)
                                    if isEmptyProfile {
                                        VStack(spacing: 24) {
                                            Spacer()
                                            Image("default_avatar")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 140, height: 140)
                                                .clipShape(Circle())
                                                .padding(.top, 36)
                                            Text("Здесь пока ничего нет. Ты можешь редактировать профиль, чтобы добавить информацию о себе")
                                                .font(.custom("BasisGrotesquePro-Regular", size: 17))
                                                .foregroundColor(.gray)
                                                .multilineTextAlignment(.center)
                                                .padding(.horizontal)
                                            Button("Заполнить профиль") {
                                                showEditProfileAlert = true
                                            }
                                            .font(.custom("BasisGrotesquePro-Regular", size: 17))
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 48)
                                            .background(Color("PrimaryBlue"))
                                            .cornerRadius(8)
                                            .padding(.horizontal, 40)
                                            .alert(isPresented: $showEditProfileAlert) {
                                                Alert(title: Text("Редактирование профиля скоро будет доступно"))
                                            }
                                            Spacer()
                                        }
                                    } else {
                                        ScrollView {
                                            VStack(spacing: 20) {
                                                // Аватар
                                                AsyncImage(url: URL(string: user.avatar?.url ?? "")) { phase in
                                                    switch phase {
                                                    case .empty:
                                                        ProgressView()
                                                            .frame(width: 140, height: 140)
                                                    case .success(let image):
                                                        image
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: 140, height: 140)
                                                            .clipShape(Circle())
                                                    case .failure:
                                                        Image("profilePhoto")
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: 140, height: 140)
                                                            .clipShape(Circle())
                                                    @unknown default:
                                                        EmptyView()
                                                    }
                                                }
                                                .padding(.top, 36)

                                                // Имя + edit
                                                HStack(spacing: 8) {
                                                    Text(user.name ?? "Пользователь")
                                                        .font(.system(size: 32, weight: .bold))
                                                    Image("editIcon")
                                                        .resizable()
                                                        .frame(width: 22, height: 22)
                                                        .foregroundColor(Color("PrimaryBlue"))
                                                }

                                                // Никнейм
                                                Text("@\(user.username ?? "")")
                                                    .foregroundColor(.gray)
                                                    .font(.system(size: 18))

                                                // Био
                                                Text(user.bio ?? "")
                                                    .multilineTextAlignment(.center)
                                                    .font(.system(size: 17))
                                                    .padding(.horizontal)

                                                // Контакты
                                                VStack(alignment: .leading, spacing: 8) {
                                                    Text("Написать мне")
                                                        .font(.system(size: 18, weight: .semibold))
                                                    HStack(spacing: 8) {
                                                        Image("telegramIcon")
                                                            .resizable()
                                                            .frame(width: 24, height: 24)
                                                        Text(user.contact ?? "")
                                                            .font(.system(size: 17))
                                                            .foregroundColor(Color("PrimaryBlue"))
                                                    }
                                                }
                                                .padding(.horizontal)

                                                Spacer()
                                            }
                                            .frame(maxWidth: 420)
                                            .padding(.bottom, 40)
                                        }
                                    }
                                } else if viewModel.isLoading {
                                    ProgressView()
                                        .padding(.top, 100)
                                }
                            }
                            // Кнопка выхода
                            Button {
                                authViewModel.logout()
                            } label: {
                                Image("logoutIcon")
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: 28, height: 28)
                                    .padding(18)
                            }
                        }
                        .navigationBarTitleDisplayMode(.inline)
                        .onAppear {
                            if let token = authViewModel.token {
                                viewModel.loadCurrentUser(token: token)
                            } else {
                                viewModel.errorMessage = "Нет JWT-токена"
                            }
                        }
                        // Кнопка сброса онбординга внизу
                        Button(action: {
                            hasCompletedOnboarding = false
                        }) {
                            Text("Сбросить онбординг")
                                .font(.custom("BasisGrotesquePro-Regular", size: 17))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(.systemGray3), lineWidth: 2)
                                )
                                .cornerRadius(8)
                                .padding(.horizontal, 40)
                        }
                        .padding(.bottom, 32)
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
}

