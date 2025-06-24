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
    @State private var isEditing = false
    @State private var editedName = ""
    @State private var editedUsername = ""
    @State private var editedBio = ""
    @State private var editedContact = ""
    @State private var isSaving = false
    @State private var saveError: String? = nil

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color(.systemGray6).ignoresSafeArea()
                if !authViewModel.isAuthorized {image.png
                    VStack {
                        Spacer()
                        Text("Чтобы посмотреть профиль, нужно войти")
                            .font(.custom("BasisGrotesquePro-Regular", size: 17))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
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
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.user == nil && !viewModel.isLoading {
                    VStack {
                        Spacer()
                        Text("Не можем загрузить данные. Проверьте подключение к интернету")
                            .font(.custom("BasisGrotesquePro-Regular", size: 17))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        Button("Повторить") {
                            if let token = authViewModel.token {
                                viewModel.loadCurrentUser(token: token)
                            }
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
                                                // Заголовок + edit
                                                HStack(alignment: .center, spacing: 8) {
                                                    Text("Профиль")
                                                        .font(.custom("BasisGrotesquePro-Medium", size: 32))
                                                        .foregroundColor(Color("PrimaryBlue"))
                                                    Button(action: {
                                                        if !isEditing {
                                                            isEditing = true
                                                            editedName = user.name ?? ""
                                                            editedUsername = user.username ?? ""
                                                            editedBio = user.bio ?? ""
                                                            editedContact = user.contact ?? ""
                                                        }
                                                    }) {
                                                        Image("editIcon")
                                                            .resizable()
                                                            .frame(width: 22, height: 22)
                                                            .foregroundColor(Color("PrimaryBlue"))
                                                    }
                                                    Spacer()
                                                    Button(action: { authViewModel.logout() }) {
                                                        Image("logoutIcon")
                                                            .renderingMode(.original)
                                                            .resizable()
                                                            .frame(width: 28, height: 28)
                                                            .padding(4)
                                                    }
                                                }
                                                .padding(.top, 24)
                                                .padding(.horizontal)
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
                                                // Имя
                                                if isEditing {
                                                    TextField("Имя", text: $editedName)
                                                        .font(.system(size: 32, weight: .bold))
                                                        .multilineTextAlignment(.center)
                                                        .padding(.horizontal)
                                                } else {
                                                    Text(user.name ?? "Пользователь")
                                                        .font(.system(size: 32, weight: .bold))
                                                }
                                                // Никнейм
                                                if isEditing {
                                                    TextField("@username", text: $editedUsername)
                                                        .foregroundColor(.gray)
                                                        .font(.system(size: 18))
                                                        .padding(.horizontal)
                                                } else {
                                                    Text("@\(user.username ?? "")")
                                                        .foregroundColor(.gray)
                                                        .font(.system(size: 18))
                                                }
                                                // Био
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text("Обо мне")
                                                        .font(.system(size: 18, weight: .semibold))
                                                        .padding(.top, 8)
                                                    if isEditing {
                                                        TextEditor(text: $editedBio)
                                                            .font(.system(size: 17))
                                                            .frame(minHeight: 80, maxHeight: 120)
                                                            .padding(.horizontal, 4)
                                                            .background(Color(.systemGray6))
                                                            .cornerRadius(8)
                                                    } else {
                                                        Text(user.bio ?? "")
                                                            .multilineTextAlignment(.leading)
                                                            .font(.system(size: 17))
                                                            .padding(.horizontal, 2)
                                                    }
                                                }
                                                .padding(.horizontal)
                                                // Контакты
                                                VStack(alignment: .leading, spacing: 8) {
                                                    Text("Написать мне")
                                                        .font(.system(size: 18, weight: .semibold))
                                                    HStack(spacing: 8) {
                                                        Image("telegramIcon")
                                                            .resizable()
                                                            .frame(width: 24, height: 24)
                                                        if isEditing {
                                                            TextField("@telegram", text: $editedContact)
                                                                .font(.system(size: 17))
                                                                .foregroundColor(Color("PrimaryBlue"))
                                                        } else {
                                                            Text(user.contact ?? "")
                                                                .font(.system(size: 17))
                                                                .foregroundColor(Color("PrimaryBlue"))
                                                        }
                                                    }
                                                }
                                                .padding(.horizontal)
                                                if isEditing {
                                                    if let error = saveError {
                                                        Text(error)
                                                            .foregroundColor(.red)
                                                            .font(.system(size: 15))
                                                    }
                                                    Button(action: {
                                                        guard let token = authViewModel.token else { return }
                                                        isSaving = true
                                                        saveError = nil
                                                        let body: [String: Any] = [
                                                            "name": editedName,
                                                            "username": editedUsername,
                                                            "bio": editedBio,
                                                            "contact": editedContact
                                                        ]
                                                        ProfileScreenWorker().patchProfile(token: token, body: body) { result in
                                                            DispatchQueue.main.async {
                                                                isSaving = false
                                                                switch result {
                                                                case .success(let updatedUser):
                                                                    viewModel.user = updatedUser
                                                                    isEditing = false
                                                                case .failure(let error):
                                                                    saveError = error.localizedDescription
                                                                }
                                                            }
                                                        }
                                                    }) {
                                                        if isSaving {
                                                            ProgressView()
                                                                .frame(height: 48)
                                                                .frame(maxWidth: .infinity)
                                                        } else {
                                                            Text("Сохранить изменения")
                                                                .font(.custom("BasisGrotesquePro-Regular", size: 17))
                                                                .foregroundColor(.white)
                                                                .frame(maxWidth: .infinity)
                                                                .frame(height: 48)
                                                                .background(Color("PrimaryBlue"))
                                                                .cornerRadius(8)
                                                                .padding(.horizontal, 40)
                                                        }
                                                    }
                                                    .padding(.top, 12)
                                                }
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

