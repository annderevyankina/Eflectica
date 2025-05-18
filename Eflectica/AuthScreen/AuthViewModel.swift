//
//  AuthViewModel.swift
//  Eflectica
//
//  Created by Анна on 09.04.2025.
//

import Foundation
import Combine

final class AuthViewModel: ObservableObject {
    private enum Const {
        static let tokenKey = "token"
        static let minPasswordLength = 6
        static let emailPattern = #"^[^@\s]+@[^@\s]+$"#
    }

    @Published var isAuthorized: Bool = false

    // Ошибки для отображения под инпутами
    @Published var emailError: String?
    @Published var passwordError: String?
    @Published var confirmPasswordError: String?

    // Ошибка входа (общая для аккаунта)
    @Published var loginAccountError: String?

    // Общая ошибка (например, сетевая)
    @Published var generalError: String?

    private var worker = AuthWorker()
    private var keychain = KeychainService()

    init() {
        let token = keychain.getString(forKey: Const.tokenKey)
        self.isAuthorized = (token != nil && !token!.isEmpty)
    }

    // MARK: – Проверка на пустое поле
    func validateEmpty(_ value: String, field: Field) -> Bool {
        if value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            switch field {
            case .email: emailError = "Заполните поле"
            case .password: passwordError = "Заполните поле"
            case .confirmPassword: confirmPasswordError = "Заполните поле"
            }
            return false
        }
        return true
    }

    // MARK: – Валидация email
    func validateEmail(_ email: String) -> Bool {
        guard validateEmpty(email, field: .email) else { return false }
        let predicate = NSPredicate(format: "SELF MATCHES %@", Const.emailPattern)
        let valid = predicate.evaluate(with: email)
        emailError = valid ? nil : "Такого адреса не существует"
        return valid
    }

    // MARK: – Валидация пароля
    func validatePassword(_ password: String) -> Bool {
        guard validateEmpty(password, field: .password) else { return false }
        let valid = password.count >= Const.minPasswordLength
        passwordError = valid ? nil : "Пароль слишком короткий"
        return valid
    }

    // MARK: – Валидация подтверждения пароля
    func validateConfirmPassword(_ password: String, _ confirmPassword: String) -> Bool {
        guard validateEmpty(confirmPassword, field: .confirmPassword) else { return false }
        let valid = password == confirmPassword
        confirmPasswordError = valid ? nil : "Пароль не совпадает. Попробуйте еще раз"
        return valid
    }

    // MARK: – Сброс ошибок
    func resetErrors() {
        emailError = nil
        passwordError = nil
        confirmPasswordError = nil
        loginAccountError = nil
        generalError = nil
    }

    // MARK: – Sign Up
    func signUp(email: String, password: String, confirmPassword: String) {
        resetErrors()
        let isEmailValid = validateEmail(email)
        let isPasswordValid = validatePassword(password)
        let isConfirmValid = validateConfirmPassword(password, confirmPassword)
        guard isEmailValid, isPasswordValid, isConfirmValid else { return }

        let endpoint = AuthEndpoint.signup
        let userData = Signup.Request.UserData(email: email, password: password)
        let requestData = Signup.Request(user: userData)

        guard let body = try? JSONEncoder().encode(requestData) else {
            print("Failed to encode signUp request")
            return
        }

        let request = Request(endpoint: endpoint, method: .post, body: body)
        worker.load(request: request) { [weak self] result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    if let urlError = error as? URLError {
                        self?.generalError = "Сервер не отвечает. Попробуйте позже"
                        self?.emailError = nil
                        self?.passwordError = nil
                        self?.confirmPasswordError = nil
                    } else {
                        self?.emailError = "Ошибка регистрации. Попробуйте еще раз"
                    }
                }
                print("Network error (signUp):", error)
            case .success(let data):
                guard let data = data else {
                    print("No data received in signUp response")
                    return
                }
                do {
                    let response = try JSONDecoder().decode(Signup.Response.self, from: data)
                    let token = response.jwt
                    self?.keychain.setString(token, forKey: Const.tokenKey)
                    DispatchQueue.main.async {
                        self?.isAuthorized = true
                    }
                    print("signUp successful, token:", token)
                } catch {
                    let raw = String(data: data, encoding: .utf8) ?? "<non-UTF8 data>"
                    DispatchQueue.main.async {
                        self?.emailError = "Ошибка регистрации. Попробуйте еще раз"
                    }
                    print("Decoding error (signUp):", error)
                    print("Raw signUp response:", raw)
                }
            }
        }
    }

    // MARK: – Sign In
    func signIn(email: String, password: String) {
        resetErrors()
        let isEmailValid = validateEmail(email)
        let isPasswordValid = validatePassword(password)
        guard isEmailValid, isPasswordValid else { return }

        let endpoint = AuthEndpoint.signin
        let userData = Signin.Request.UserData(email: email, password: password)
        let requestData = Signin.Request(user: userData)

        guard let body = try? JSONEncoder().encode(requestData) else {
            print("Failed to encode signIn request")
            return
        }

        let request = Request(endpoint: endpoint, method: .post, body: body)
        worker.load(request: request) { [weak self] result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    if let urlError = error as? URLError {
                        self?.generalError = "Сервер не отвечает. Попробуйте позже"
                        self?.loginAccountError = nil
                    } else {
                        self?.loginAccountError = "Аккаунт не найден. Проверьте данные входа"
                    }
                }
                print("Network error (signIn):", error)
            case .success(let data):
                guard let data = data else {
                    print("No data received in signIn response")
                    return
                }
                do {
                    let response = try JSONDecoder().decode(Signin.Response.self, from: data)
                    let token = response.jwt
                    self?.keychain.setString(token, forKey: Const.tokenKey)
                    DispatchQueue.main.async {
                        self?.isAuthorized = true
                    }
                    print("signIn successful, token:", token)
                } catch {
                    let raw = String(data: data, encoding: .utf8) ?? "<non-UTF8 data>"
                    DispatchQueue.main.async {
                        if raw.contains("Unauthorized") || raw.contains("Sign In Failed") || raw.contains("\"is_success\":false") {
                            self?.loginAccountError = "Аккаунт не найден. Проверьте данные входа"
                        } else {
                            self?.generalError = "Сервер не отвечает. Попробуйте позже"
                        }
                    }
                    print("Decoding error (signIn):", error)
                    print("Raw signIn response:", raw)
                }
            }
        }
    }

    // MARK: – Get Users
    func getUsers() {
        let token = keychain.getString(forKey: Const.tokenKey) ?? ""
        let request = Request(endpoint: AuthEndpoint.users(token: token))
        worker.load(request: request) { result in
            switch result {
            case .failure(let error):
                print("Network error (getUsers):", error)
            case .success(let data):
                guard let data = data else {
                    print("No data received in getUsers response")
                    return
                }
                if let string = String(data: data, encoding: .utf8) {
                    print("getUsers response:", string)
                } else {
                    print("Failed to decode getUsers data into a string")
                }
            }
        }
    }

    // MARK: – Logout
    func logout() {
        keychain.removeData(forKey: Const.tokenKey)
        DispatchQueue.main.async {
            self.isAuthorized = false
        }
    }

    enum Field {
        case email
        case password
        case confirmPassword
    }
}
