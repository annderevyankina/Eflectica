//
//  FilterView.swift
//  Eflectica
//
//  Created by Анна on 20.05.2025.
//

import SwiftUI

struct FilterView: View {
    @Environment(\.dismiss) private var dismiss
    
    private let primaryBlue = Color("PrimaryBlue")
    private let textColor = Color("TextColor")
    private let greyColor = Color("Grey")
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 24) {
                // Tasks section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Задачи")
                        .font(.custom("BasisGrotesquePro-Medium", size: 24))
                        .foregroundStyle(textColor)
                    
                    // Здесь будет список задач
                }
                .padding(.horizontal)
                
                // Programs section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Программы")
                        .font(.custom("BasisGrotesquePro-Medium", size: 24))
                        .foregroundStyle(textColor)
                    
                    // Здесь будет список программ
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Save button
                Button(action: {
                    dismiss()
                }) {
                    Text("Сохранить")
                        .font(.custom("BasisGrotesquePro-Medium", size: 17))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(primaryBlue)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
            }
            .padding(.top, 24)
            .navigationTitle("Фильтры")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundStyle(textColor)
                    }
                }
            }
        }
    }
} 
