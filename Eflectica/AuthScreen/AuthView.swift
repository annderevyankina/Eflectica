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
    @State private var showConfirmPassword = false

    @Environment(\.dismiss) private var dismiss

    private let primaryColor = Color("PrimaryBlue")
    private let greyColor = Color("Grey")
    private let textColor = Color("TextColor")
    private let whiteColor = Color("WhiteColor")
    private let formWidth: CGFloat = 340
    private let horizontalPadding: CGFloat = 16

    var body: some View {
        NavigationStack {
            ZStack {
                if let error = viewModel.generalError, error.lowercased().contains("сервер") || error.lowercased().contains("интернет") {
                    VStack {
                        Spacer()
                        Text("Не можем загрузить данные. Проверьте подключение к интернету")
                            .font(.custom("BasisGrotesquePro-Regular", size: 17))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color("LightGrey").ignoresSafeArea())
                } else {
                    Image("AuthBackground")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                    GeometryReader { geo in
                        ScrollView(showsIndicators: false) {
                            VStack {
                                Spacer(minLength: max((geo.size.height - 480) / 2, 0))

                                VStack(spacing: 24) {
                                    // Заголовок
                                    Text(currentScreen == .login ? "Вход" : "Регистрация")
                                        .font(.custom("BasisGrotesquePro-Medium", size: 32))
                                        .foregroundColor(primaryColor)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .padding(.bottom, 6)

                                    // Поля ввода
                                    VStack(spacing: 12) {
                                        // Email
                                        TextField("Адрес почты", text: $email)
                                            .textInputAutocapitalization(.never)
                                            .disableAutocorrection(true)
                                            .padding(.vertical, 14)
                                            .padding(.horizontal, 16)
                                            .background(whiteColor)
                                            .cornerRadius(8)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(emailErrorColor, lineWidth: 1)
                                            )
                                            .foregroundColor(textColor)
                                            .font(.custom("BasisGrotesquePro-Regular", size: 17))
                                        // Сообщение об ошибке email (только если это не общая ошибка)
                                        if let error = currentEmailError {
                                            Text(error)
                                                .foregroundColor(.red)
                                                .font(.custom("BasisGrotesquePro-Regular", size: 13))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.leading, 4)
                                        }

                                        // Пароль
                                        ZStack(alignment: .trailing) {
                                            Group {
                                                if showPassword {
                                                    TextField("Пароль", text: $password)
                                                        .textInputAutocapitalization(.never)
                                                        .disableAutocorrection(true)
                                                        .foregroundColor(textColor)
                                                        .font(.custom("BasisGrotesquePro-Regular", size: 17))
                                                } else {
                                                    SecureField("Пароль", text: $password)
                                                        .textInputAutocapitalization(.never)
                                                        .disableAutocorrection(true)
                                                        .foregroundColor(textColor)
                                                        .font(.custom("BasisGrotesquePro-Regular", size: 17))
                                                }
                                            }
                                            .padding(.vertical, 14)
                                            .padding(.horizontal, 16)
                                            .background(whiteColor)
                                            .cornerRadius(8)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(passwordErrorColor, lineWidth: 1)
                                            )

                                            Button {
                                                showPassword.toggle()
                                            } label: {
                                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                                    .foregroundColor(greyColor)
                                                    .padding(.trailing, 16)
                                            }
                                        }
                                        // Сообщение об ошибке пароля (только если это не общая ошибка)
                                        if let error = currentPasswordError {
                                            Text(error)
                                                .foregroundColor(.red)
                                                .font(.custom("BasisGrotesquePro-Regular", size: 13))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.leading, 4)
                                        }

                                        // Подтверждение пароля (только при регистрации)
                                        if currentScreen == .register {
                                            ZStack(alignment: .trailing) {
                                                Group {
                                                    if showConfirmPassword {
                                                        TextField("Пароль еще раз", text: $confirmPassword)
                                                            .textInputAutocapitalization(.never)
                                                            .disableAutocorrection(true)
                                                            .foregroundColor(textColor)
                                                            .font(.custom("BasisGrotesquePro-Regular", size: 17))
                                                    } else {
                                                        SecureField("Пароль еще раз", text: $confirmPassword)
                                                            .textInputAutocapitalization(.never)
                                                            .disableAutocorrection(true)
                                                            .foregroundColor(textColor)
                                                            .font(.custom("BasisGrotesquePro-Regular", size: 17))
                                                    }
                                                }
                                                .padding(.vertical, 14)
                                                .padding(.horizontal, 16)
                                                .background(whiteColor)
                                                .cornerRadius(8)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .stroke(confirmPasswordErrorColor, lineWidth: 1)
                                                )

                                                Button {
                                                    showConfirmPassword.toggle()
                                                } label: {
                                                    Image(systemName: showConfirmPassword ? "eye.slash" : "eye")
                                                        .foregroundColor(greyColor)
                                                        .padding(.trailing, 16)
                                                }
                                            }
                                            // Сообщение об ошибке подтверждения пароля
                                            if let error = viewModel.confirmPasswordError, !hasGeneralOrLoginError {
                                                Text(error)
                                                    .foregroundColor(.red)
                                                    .font(.custom("BasisGrotesquePro-Regular", size: 13))
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .padding(.leading, 4)
                                            }
                                        }
                                    }

                                    // Сообщения об ошибках входа/сервера - перед синей кнопкой
                                    if let error = loginOrGeneralError {
                                        Text(error)
                                            .foregroundColor(.red)
                                            .font(.custom("BasisGrotesquePro-Regular", size: 15))
                                            .multilineTextAlignment(.center)
                                            .padding(.top, 12)
                                    }

                                    // Кнопки
                                    VStack(spacing: 12) {
                                        if currentScreen == .login {
                                            Button {
                                                viewModel.signIn(email: email, password: password)
                                            } label: {
                                                Text("Войти")
                                                    .font(.custom("BasisGrotesquePro-Medium", size: 17))
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
                                                    confirmPassword = ""
                                                    viewModel.resetErrors()
                                                }
                                            } label: {
                                                Text("Зарегистрироваться")
                                                    .font(.custom("BasisGrotesquePro-Medium", size: 17))
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
                                                viewModel.signUp(email: email, password: password, confirmPassword: confirmPassword)
                                            } label: {
                                                Text("Зарегистрироваться")
                                                    .font(.custom("BasisGrotesquePro-Medium", size: 17))
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
                                                    viewModel.resetErrors()
                                                }
                                            } label: {
                                                Text("Войти")
                                                    .font(.custom("BasisGrotesquePro-Medium", size: 17))
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
            }
            .onChange(of: viewModel.isAuthorized) { isAuthorized in
                if isAuthorized {
                    dismiss()
                }
            }
        }
    }

    // MARK: - Errors

    private var loginOrGeneralError: String? {
        if currentScreen == .login {
            return viewModel.generalError ?? viewModel.loginAccountError
        } else {
            return viewModel.generalError
        }
    }

    private var hasGeneralOrLoginError: Bool {
        if currentScreen == .login {
            return viewModel.generalError != nil || viewModel.loginAccountError != nil
        } else {
            return viewModel.generalError != nil
        }
    }

    private var currentEmailError: String? {
        if hasGeneralOrLoginError { return nil }
        return viewModel.emailError
    }

    private var currentPasswordError: String? {
        if hasGeneralOrLoginError { return nil }
        return viewModel.passwordError
    }

    private var emailErrorColor: Color {
        (currentEmailError != nil && !hasGeneralOrLoginError) ? .red : greyColor
    }

    private var passwordErrorColor: Color {
        (currentPasswordError != nil && !hasGeneralOrLoginError) ? .red : greyColor
    }

    private var confirmPasswordErrorColor: Color {
        (viewModel.confirmPasswordError != nil && !hasGeneralOrLoginError) ? .red : greyColor
    }
}

