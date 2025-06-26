//
//  ProfileScreenView.swift
//  Eflectica
//
//  Created by Анна on 20.05.2025.
//

import SwiftUI

struct ProfileScreenView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
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
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var showDeleteAccountAlert = false
    @State private var isDeletingAccount = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color(.systemGray6).ignoresSafeArea()
                if !authViewModel.isAuthorized {
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
                } else if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.user == nil {
                    ZStack(alignment: .topTrailing) {
                        VStack {
                            Spacer()
                            Text(viewModel.errorMessage ?? "Не можем загрузить данные. Проверьте подключение к интернету")
                                .font(.custom("BasisGrotesquePro-Regular", size: 17))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                            Button("Повторить") {
                                if let token = authViewModel.token {
                                    viewModel.loadCurrentUser(token: token)
                                } else {
                                    viewModel.errorMessage = "Нет JWT-токена"
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
                        Button(action: { 
                            authViewModel.logout()
                            viewModel.user = nil
                        }) {
                            Image("logoutIcon")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 28, height: 28)
                                .padding(12)
                        }
                    }
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
                                        ZStack(alignment: .topTrailing) {
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
                                            Button(action: { 
                                                authViewModel.logout()
                                                viewModel.user = nil
                                            }) {
                                                Image("logoutIcon")
                                                    .renderingMode(.original)
                                                    .resizable()
                                                    .frame(width: 28, height: 28)
                                                    .padding(12)
                                            }
                                        }
                                    } else {
                                        ScrollView {
                                            VStack(spacing: 20) {
                                                // Заголовок 
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
                                                    Button(action: { 
                                                        authViewModel.logout()
                                                        viewModel.user = nil
                                                    }) {
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
                                                Group {
                                                    if isEditing {
                                                        Button(action: { showImagePicker = true }) {
                                                            if let selectedImage = selectedImage {
                                                                Image(uiImage: selectedImage)
                                                                    .resizable()
                                                                    .scaledToFill()
                                                                    .frame(width: 140, height: 140)
                                                                    .clipShape(Circle())
                                                            } else {
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
                                                            }
                                                        }
                                                        .buttonStyle(PlainButtonStyle())
                                                        .padding(.top, 36)
                                                        .sheet(isPresented: $showImagePicker) {
                                                            ImagePicker(selectedImage: $selectedImage)
                                                        }
                                                    } else {
                                                        if let selectedImage = selectedImage {
                                                            Image(uiImage: selectedImage)
                                                                .resizable()
                                                                .scaledToFill()
                                                                .frame(width: 140, height: 140)
                                                                .clipShape(Circle())
                                                        } else {
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
                                                        }
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
                                                        .padding(.horizontal, 12)
                                                        .padding(.vertical, 8)
                                                        .background(Color.white)
                                                        .cornerRadius(8)
                                                        .padding(.horizontal, 24)
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
                                                            .padding(8)
                                                            .background(Color.white)
                                                            .cornerRadius(8)
                                                    } else {
                                                        Text(user.bio ?? "")
                                                            .multilineTextAlignment(.leading)
                                                            .font(.system(size: 17))
                                                            .padding(.horizontal, 2)
                                                    }
                                                }
                                                .padding(.horizontal, 16)
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
                                                                .padding(.vertical, 8)
                                                                .padding(.horizontal, 8)
                                                                .background(Color.white)
                                                                .cornerRadius(8)
                                                        } else {
                                                            Text(user.contact ?? "")
                                                                .font(.system(size: 17))
                                                                .foregroundColor(Color("PrimaryBlue"))
                                                        }
                                                    }
                                                }
                                                .padding(.horizontal, 16)
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
                                                            // Для отправки фото потребуется доработать backend и worker
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
                                                                .background(RoundedRectangle(cornerRadius: 8).fill(Color("PrimaryBlue")))
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
                                }
                            }
                        }
                        .navigationBarTitleDisplayMode(.inline)
                        .onAppear {
                            if authViewModel.isAuthorized, let token = authViewModel.token, viewModel.user == nil, !viewModel.isLoading {
                                viewModel.loadCurrentUser(token: token)
                            }
                        }
                        // Кнопка сброса онбординга
                        Button(action: {
                            authViewModel.hasCompletedOnboarding = false
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
                        .padding(.bottom, 16)
                        .frame(maxWidth: .infinity)
                        
                        // Кнопка удаления аккаунта
                        Button(action: {
                            showDeleteAccountAlert = true
                        }) {
                            if isDeletingAccount {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: Color("DangerColor")))
                                    .frame(height: 44)
                            } else {
                                Text("Удалить аккаунт")
                                    .font(.custom("BasisGrotesquePro-Regular", size: 17))
                                    .foregroundColor(Color("DangerColor"))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                            }
                        }
                        .disabled(isDeletingAccount)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color("DangerColor"), lineWidth: 2)
                        )
                        .cornerRadius(8)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 32)
                        .frame(maxWidth: .infinity)
                        .alert("Ты точно хочешь удалить профиль?", isPresented: $showDeleteAccountAlert) {
                            Button("Нет", role: .cancel) {
                                // Алерт автоматически исчезнет
                            }
                            Button("Да", role: .destructive) {
                                deleteAccount()
                            }
                        } message: {
                            Text("Это действие нельзя отменить. Все твои данные будут удалены навсегда.")
                        }
                    }
                }
            }
        }
    }
    
    private func deleteAccount() {
        guard let token = authViewModel.token else { return }
        
        isDeletingAccount = true
        
        ProfileScreenWorker().deleteProfile(token: token) { result in
            DispatchQueue.main.async {
                isDeletingAccount = false
                
                switch result {
                case .success:
                    // Успешно удалили аккаунт, выходим из системы
                    authViewModel.logout()
                    viewModel.user = nil
                case .failure(let error):
                    // Показываем ошибку пользователю
                    print("Ошибка удаления аккаунта: \(error)")
                }
            }
        }
    }
}

