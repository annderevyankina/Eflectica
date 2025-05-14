//
//  AuthViewModel.swift
//  Eflectica
//
//  Created by Анна on 09.04.2025.
//

import Foundation

final class AuthViewModel: ObservableObject {
    private enum Const {
        static let tokenKey = "token"
    }

    @Published var isAuthorized: Bool

    private var worker = AuthWorker()
    private var keychain = KeychainService()

    init() {
        // Проверяем токен в keychain при запуске
        let token = keychain.getString(forKey: Const.tokenKey)
        self.isAuthorized = (token != nil && !token!.isEmpty)
    }

    // MARK: – Sign Up

    func signUp(email: String, password: String) {
        let endpoint = AuthEndpoint.signup

        let userData = Signup.Request.UserData(
            email: email,
            password: password
        )
        let requestData = Signup.Request(user: userData)

        guard let body = try? JSONEncoder().encode(requestData) else {
            print("Failed to encode signUp request")
            return
        }

        let request = Request(endpoint: endpoint, method: .post, body: body)
        worker.load(request: request) { [weak self] result in
            switch result {
            case .failure(let error):
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
                    print("Decoding error (signUp):", error)
                    print("Raw signUp response:", raw)
                }
            }
        }
    }

    // MARK: – Sign In

    func signIn(email: String, password: String) {
        let endpoint = AuthEndpoint.signin

        let userData = Signin.Request.UserData(
            email: email,
            password: password
        )
        let requestData = Signin.Request(user: userData)

        guard let body = try? JSONEncoder().encode(requestData) else {
            print("Failed to encode signIn request")
            return
        }

        let request = Request(endpoint: endpoint, method: .post, body: body)
        worker.load(request: request) { [weak self] result in
            switch result {
            case .failure(let error):
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
}




