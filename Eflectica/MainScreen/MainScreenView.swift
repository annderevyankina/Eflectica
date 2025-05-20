//
//  MainScreenView.swift
//  Eflectica
//
//  Created by Анна on 09.04.2025.
//

import SwiftUI

struct MainScreenView: View {
    @ObservedObject var viewModel: MainScreenViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = true

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Добро пожаловать на главный экран!")
                    .font(.title)
                    .padding()

                Button(action: {
                    authViewModel.logout()
                }) {
                    Text("Выйти")
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }

                Button(action: {
                    hasCompletedOnboarding = false
                }) {
                    Text("Показать онбординг снова")
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(8)
                }
            }
            .navigationTitle("Главный экран")
        }
    }
}





