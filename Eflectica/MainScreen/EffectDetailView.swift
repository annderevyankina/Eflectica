//
//  EffectDetailView.swift
//  Eflectica
//
//  Created by Анна on 21.05.2025.
//

import SwiftUI

struct EffectDetailView: View {
    @StateObject var viewModel: EffectDetailViewModel
    
    private let primaryBlue = Color("PrimaryBlue")
    private let textColor = Color("TextColor")
    private let greyColor = Color("Grey")
    
    var body: some View {
        ScrollView {
            if let effectCard = viewModel.effectCard {
                VStack(alignment: .leading, spacing: 24) {
                    // Header section with title and actions
                    headerSection(effectCard: effectCard)
                    
                    // Rating section
                    ratingSection(effectCard: effectCard)
                    
                    // Before/After Images
                    beforeAfterSection(effectCard: effectCard)
                    
                    // Description
                    descriptionSection(effectCard: effectCard)
                    
                    // Install button
                    installButtonSection(effectCard: effectCard)
                    
                    // Author section
                    authorSection()
                    
                    // Programs section
                    programsSection(effectCard: effectCard)
                    
                    // Category section
                    categorySection(effectCard: effectCard)
                    
                    // Tasks section
                    tasksSection(effectCard: effectCard)
                    
                    // Instructions section
                    instructionsSection(effectCard: effectCard)
                    
                    // Comments section
                    commentsSection()
                }
                .padding(.vertical, 24)
            } else if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
            } else if let error = viewModel.error {
                errorSection(error: error)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchEffectDetails()
        }
    }
    
    // MARK: - Header Section
    private func headerSection(effectCard: EffectCardViewModel) -> some View {
        HStack {
            Text(effectCard.name)
                .font(.custom("BasisGrotesquePro-Medium", size: 32))
                .foregroundStyle(primaryBlue)
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: {
                    // Share action
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundStyle(textColor)
                        .font(.system(size: 20))
                }
                
                Button(action: {
                    // Add to collection action
                }) {
                    Image(systemName: "plus")
                        .foregroundStyle(textColor)
                        .font(.system(size: 20))
                }
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Rating Section
    private func ratingSection(effectCard: EffectCardViewModel) -> some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .foregroundStyle(.yellow)
                .font(.system(size: 16))
            Text(effectCard.formattedRating)
                .font(.custom("BasisGrotesquePro-Medium", size: 17))
                .foregroundStyle(textColor)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Before/After Section
    private func beforeAfterSection(effectCard: EffectCardViewModel) -> some View {
        VStack(spacing: 16) {
            // Before Image
            VStack(spacing: 8) {
                AsyncImage(url: URL(string: effectCard.beforeImageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(greyColor.opacity(0.2))
                }
                .frame(height: 200)
                .clipped()
                .cornerRadius(16)
                
                Text("До применения")
                    .font(.custom("BasisGrotesquePro-Regular", size: 15))
                    .foregroundStyle(greyColor)
            }
            
            // After Image
            VStack(spacing: 8) {
                AsyncImage(url: URL(string: effectCard.afterImageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(greyColor.opacity(0.2))
                }
                .frame(height: 200)
                .clipped()
                .cornerRadius(16)
                
                Text("После применения")
                    .font(.custom("BasisGrotesquePro-Regular", size: 15))
                    .foregroundStyle(greyColor)
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Description Section
    private func descriptionSection(effectCard: EffectCardViewModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Описание")
                .font(.custom("BasisGrotesquePro-Medium", size: 20))
                .foregroundStyle(textColor)
            
            Text(effectCard.description)
                .font(.custom("BasisGrotesquePro-Regular", size: 15))
                .foregroundStyle(textColor)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Install Button Section
    private func installButtonSection(effectCard: EffectCardViewModel) -> some View {
        Button(action: {
            // Install action
        }) {
            Text("Установить")
                .font(.custom("BasisGrotesquePro-Medium", size: 17))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(primaryBlue)
                .cornerRadius(12)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Author Section
    private func authorSection() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Автор")
                .font(.custom("BasisGrotesquePro-Medium", size: 20))
                .foregroundStyle(textColor)
            
            // Author info placeholder
            Text("Информация об авторе")
                .font(.custom("BasisGrotesquePro-Regular", size: 15))
                .foregroundStyle(textColor)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Programs Section
    private func programsSection(effectCard: EffectCardViewModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Программы")
                .font(.custom("BasisGrotesquePro-Medium", size: 20))
                .foregroundStyle(textColor)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(effectCard.programs, id: \.self) { program in
                        Text(program)
                            .font(.custom("BasisGrotesquePro-Regular", size: 15))
                            .foregroundStyle(primaryBlue)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Category Section
    private func categorySection(effectCard: EffectCardViewModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Категории")
                .font(.custom("BasisGrotesquePro-Medium", size: 20))
                .foregroundStyle(textColor)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(effectCard.categoryList, id: \.self) { category in
                        Text(category)
                            .font(.custom("BasisGrotesquePro-Regular", size: 15))
                            .foregroundStyle(primaryBlue)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Tasks Section
    private func tasksSection(effectCard: EffectCardViewModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Задачи")
                .font(.custom("BasisGrotesquePro-Medium", size: 20))
                .foregroundStyle(textColor)
            
            // Tasks placeholder
            Text("Список задач")
                .font(.custom("BasisGrotesquePro-Regular", size: 15))
                .foregroundStyle(textColor)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Instructions Section
    private func instructionsSection(effectCard: EffectCardViewModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Инструкция")
                .font(.custom("BasisGrotesquePro-Medium", size: 20))
                .foregroundStyle(textColor)
            
            // Instructions placeholder
            Text("Инструкция по применению")
                .font(.custom("BasisGrotesquePro-Regular", size: 15))
                .foregroundStyle(textColor)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Comments Section
    private func commentsSection() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Комментарии")
                .font(.custom("BasisGrotesquePro-Medium", size: 20))
                .foregroundStyle(textColor)
            
            // Comments placeholder
            Text("Список комментариев")
                .font(.custom("BasisGrotesquePro-Regular", size: 15))
                .foregroundStyle(textColor)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Error Section
    private func errorSection(error: Error) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundStyle(.red)
            
            Text("Ошибка загрузки")
                .font(.custom("BasisGrotesquePro-Medium", size: 20))
                .foregroundStyle(textColor)
            
            Text(error.localizedDescription)
                .font(.custom("BasisGrotesquePro-Regular", size: 15))
                .foregroundStyle(textColor)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Preview Provider
struct EffectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EffectDetailView(viewModel: EffectDetailViewModel(effectId: 1))
    }
}

