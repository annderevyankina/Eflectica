//
//  ProfileScreenView.swift
//  Eflectica
//
//  Created by Анна on 20.05.2025.
//

import SwiftUI

struct ProfileScreenView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = true
    @StateObject private var viewModel = ProfileScreenViewModel()

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                Group {
                    if viewModel.isLoading {
                        ProgressView()
                            .padding(.top, 100)
                    } else if let user = viewModel.user {
                        ScrollView {
                            VStack(spacing: 20) {
                                // Аватар
                                AsyncImage(url: URL(string: user.avatar.url)) { phase in
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
                                Text("@\(user.username)")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 18))

                                // Био
                                Text(user.bio)
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
                                        Text(user.contact)
                                            .font(.system(size: 17))
                                            .foregroundColor(Color("PrimaryBlue"))
                                    }
                                }
                                .padding(.horizontal)

                                // Кнопка онбординга
                                Button("Смотреть онбординг") {
                                    hasCompletedOnboarding = false
                                }
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .padding(.horizontal)
                                .padding(.top, 18)

                                Spacer()
                            }
                            .frame(maxWidth: 420)
                            .padding(.bottom, 40)
                        }
                    } else if let error = viewModel.errorMessage {
                        Text("Ошибка: \(error)")
                            .foregroundColor(.red)
                            .padding(.top, 100)
                    } else {
                        Text("Нет данных")
                            .foregroundColor(.gray)
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
            .background(Color(.systemGray6).ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                // теперь вызываем метод с параметром token
                if let token = authViewModel.token {
                    print("ProfileScreenView onAppear token:", token)
                    viewModel.loadCurrentUser(token: token)
                } else {
                    viewModel.errorMessage = "Нет JWT-токена"
                }
            }
        }
    }
}

