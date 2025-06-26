//
//  EditProfileSheet.swift
//  Eflectica
//
//  Created by Анна on 31.05.2025.
//

import SwiftUI

struct EditProfileSheet: View {
    @Binding var isPresented: Bool
    @StateObject private var viewModel = EditProfileViewModel()
    let currentUser: User
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 6)
                    .padding(.top, 8)
                
                Text("Редактировать профиль")
                    .font(.headline)
                    .padding(.top)
                
                VStack(spacing: 16) {
                    TextField("Имя пользователя", text: $viewModel.username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Обо мне", text: $viewModel.bio, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(3...6)
                    
                    TextField("Контакт", text: $viewModel.contact)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Портфолио (необязательно)", text: $viewModel.portfolio)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal)
                
                HStack(spacing: 16) {
                    Button("Отмена") {
                        isPresented = false
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.primary)
                    .cornerRadius(10)
                    
                    Button("Сохранить") {
                        viewModel.saveProfile()
                        isPresented = false
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(viewModel.isLoading)
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .onAppear {
            viewModel.loadUserData(currentUser)
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(20)
    }
}
