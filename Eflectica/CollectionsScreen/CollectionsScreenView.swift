//
//  CollectionsScreenView.swift
//  Eflectica
//
//  Created by Анна on 18.05.2025.
//

import SwiftUI

struct CollectionsScreenView: View {
    @ObservedObject var viewModel: CollectionsScreenViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showAuth = false

    var body: some View {
        if viewModel.greeting == "network_error" {
            VStack {
                Spacer()
                Text("Не можем загрузить данные. Проверьте подключение к интернету")
                    .font(.custom("BasisGrotesquePro-Regular", size: 17))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                Button("Повторить") {
//                    $viewModel.loadCollections
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
            .background(Color(.systemGray6).ignoresSafeArea())
        } else if !authViewModel.isAuthorized {
            VStack(spacing: 16) {
                Text("Чтобы посмотреть коллекции, нужно войти")
                    .font(.custom("BasisGrotesquePro-Regular", size: 17))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.top, 100)
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
            }
        } else {
            Text(viewModel.greeting)
        }
    }
}
