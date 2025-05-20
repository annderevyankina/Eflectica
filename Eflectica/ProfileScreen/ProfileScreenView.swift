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

    var body: some View {
        VStack(spacing: 24) {
            Text("Профиль")
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
        .navigationTitle("Профиль")
    }
}
