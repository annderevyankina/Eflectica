//
//  AuthView.swift
//  Eflectica
//
//  Created by Анна on 09.04.2025.
//

import SwiftUI

enum AuthScreen {
    case login
    case register
}

struct AuthView: View {
    @ObservedObject var viewModel: AuthViewModel

    @State private var currentScreen: AuthScreen = .login
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showPassword = false

    // Цвета из ассетов
    private let primaryColor = Color("PrimaryBlue")
    private let greyColor = Color("Grey")
    private let textColor = Color("TextColor")
    private let whiteColor = Color("White")
    private let formWidth: CGFloat = 340
    private let horizontalPadding: CGFloat = 16

    var body: some View {
        NavigationStack {
            ZStack {
                // Фон на весь экран
                Image("AuthBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                GeometryReader { geo in
                    ScrollView(showsIndicators: false) {
                        VStack {
                            Spacer(minLength: max((geo.size.height - 420) / 2, 0)) // Центрирование по вертикали

                            VStack(spacing: 24) {
                                // Заголовок
                                Text(currentScreen == .login ? "Вход" : "Регистрация")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(primaryColor)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.bottom, 12)

                                // Поля ввода
                                VStack(spacing: 12) {
                                    TextField("Адрес почты", text: $email)
                                        .textInputAutocapitalization(.never)
                                        .disableAutocorrection(true)
                                        .padding(.vertical, 14)
                                        .padding(.horizontal, 16)
                                        .background(whiteColor)
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(greyColor, lineWidth: 1)
                                        )
                                        .foregroundColor(textColor)
                                        .font(.system(size: 17))

                                    ZStack(alignment: .trailing) {
                                        Group {
                                            if showPassword {
                                                TextField("Пароль", text: $password)
                                                    .textInputAutocapitalization(.never)
                                                    .disableAutocorrection(true)
                                                    .foregroundColor(textColor)
                                            } else {
                                                SecureField("Пароль", text: $password)
                                                    .textInputAutocapitalization(.never)
                                                    .disableAutocorrection(true)
                                                    .foregroundColor(textColor)
                                            }
                                        }
                                        .padding(.vertical, 14)
                                        .padding(.horizontal, 16)
                                        .background(whiteColor)
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(greyColor, lineWidth: 1)
                                        )
                                        .font(.system(size: 17))

                                        Button {
                                            showPassword.toggle()
                                        } label: {
                                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                                .foregroundColor(greyColor)
                                                .padding(.trailing, 16)
                                        }
                                    }

                                    if currentScreen == .register {
                                        SecureField("Пароль еще раз", text: $confirmPassword)
                                            .padding(.vertical, 14)
                                            .padding(.horizontal, 16)
                                            .foregroundColor(textColor)
                                            .background(whiteColor)
                                            .cornerRadius(8)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(greyColor, lineWidth: 1)
                                            )
                                            .font(.system(size: 17))
                                    }
                                }

                                // Кнопки
                                VStack(spacing: 12) {
                                    if currentScreen == .login {
                                        Button {
                                            viewModel.signIn(email: email, password: password)
                                        } label: {
                                            Text("Войти")
                                                .font(.system(size: 17, weight: .semibold))
                                                .foregroundColor(whiteColor)
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 48)
                                                .background(primaryColor)
                                                .cornerRadius(8)
                                        }

                                        Button {
                                            withAnimation {
                                                currentScreen = .register
                                                password = ""
                                            }
                                        } label: {
                                            Text("Зарегистрироваться")
                                                .font(.system(size: 17, weight: .semibold))
                                                .foregroundColor(primaryColor)
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 48)
                                                .background(whiteColor)
                                                .cornerRadius(8)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .stroke(greyColor, lineWidth: 1)
                                                )
                                        }
                                    } else {
                                        Button {
                                            guard password == confirmPassword else {
                                                print("Пароли не совпадают")
                                                return
                                            }
                                            viewModel.signUp(email: email, password: password)
                                        } label: {
                                            Text("Зарегистрироваться")
                                                .font(.system(size: 17, weight: .semibold))
                                                .foregroundColor(whiteColor)
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 48)
                                                .background(primaryColor)
                                                .cornerRadius(8)
                                        }

                                        Button {
                                            withAnimation {
                                                currentScreen = .login
                                                password = ""
                                                confirmPassword = ""
                                            }
                                        } label: {
                                            Text("Войти")
                                                .font(.system(size: 17, weight: .semibold))
                                                .foregroundColor(primaryColor)
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 48)
                                                .background(whiteColor)
                                                .cornerRadius(8)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .stroke(greyColor, lineWidth: 1)
                                                )
                                        }
                                    }
                                }
                            }
                            .frame(maxWidth: formWidth)
                            .padding(.horizontal, horizontalPadding)
                            .padding(.vertical, 32)
                            .background(
                                whiteColor.opacity(0.0)
                                    .cornerRadius(24)
                            )
                            .frame(maxWidth: .infinity)

                            Spacer(minLength: 0)
                        }
                        .frame(minHeight: geo.size.height)
                    }
                    .scrollDisabled(true)
                }
            }
            // Новый способ навигации: переход на OnboardingView при isAuthorized = true
            .navigationDestination(isPresented: $viewModel.isAuthorized) {
                OnboardingView()
            }
        }
    }
}




