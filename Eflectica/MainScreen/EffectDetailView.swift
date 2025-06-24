//
//  EffectDetailView.swift
//  Eflectica
//
//  Created by Анна on 21.05.2025.
//

import SwiftUI
import UIKit

struct EffectDetailView: View {
    @StateObject var viewModel: EffectDetailViewModel
    @State private var isShareSheetPresented = false
    @State private var isAddToCollectionPresented = false
    
    private let primaryBlue = Color("PrimaryBlue")
    private let textColor = Color("TextColor")
    private let greyColor = Color("Grey")
    
    var body: some View {
        ScrollView {
            if let effectCard = viewModel.effectCard {
                VStack(alignment: .center, spacing: 24) {
                    // Заголовок
                    Text(effectCard.name)
                        .font(.custom("BasisGrotesquePro-Medium", size: 32))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.top, 16)
                        .padding(.bottom, 8)
                        .frame(maxWidth: .infinity)
                    // Блок до/после
                    VStack(spacing: 16) {
                        VStack(spacing: 4) {
                            AsyncImage(url: URL(string: effectCard.beforeImageUrl)) { image in
                                image.resizable().aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Rectangle().fill(greyColor.opacity(0.2))
                            }
                            .frame(height: 180)
                            .clipped()
                            Text("До применения")
                                .font(.custom("BasisGrotesquePro-Regular", size: 15))
                                .foregroundColor(greyColor)
                        }
                        VStack(spacing: 4) {
                            AsyncImage(url: URL(string: effectCard.afterImageUrl)) { image in
                                image.resizable().aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Rectangle().fill(greyColor.opacity(0.2))
                            }
                            .frame(height: 180)
                            .clipped()
                            Text("После применения")
                                .font(.custom("BasisGrotesquePro-Regular", size: 15))
                                .foregroundColor(greyColor)
                        }
                    }
                    // Описание
                    Text(effectCard.description)
                        .font(.custom("BasisGrotesquePro-Regular", size: 17))
                        .foregroundColor(textColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    // Кнопки
                    HStack(spacing: 8) {
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "arrow.down.to.line.alt")
                                Text("Установить")
                            }
                            .font(.custom("BasisGrotesquePro-Medium", size: 17))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(primaryBlue)
                            .cornerRadius(12)
                        }
                        Button(action: { isAddToCollectionPresented = true }) {
                            Image(systemName: "plus")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(10)
                                .frame(width: 42, height: 42)
                                .foregroundColor(textColor)
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(greyColor, lineWidth: 2)
                                        .background(Color("WhiteColor").cornerRadius(6))
                                )
                        }
                        Button(action: { isShareSheetPresented = true }) {
                            Image(systemName: "square.and.arrow.up")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(10)
                                .frame(width: 42, height: 42)
                                .foregroundColor(textColor)
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(greyColor, lineWidth: 2)
                                        .background(Color("WhiteColor").cornerRadius(6))
                                )
                        }
                    }
                    .padding(.horizontal)
                    // Автор и рейтинг
                    HStack {
                        Spacer()
                        VStack {
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(Color.pink)
                                    .font(.system(size: 20))
                                Text(effectCard.formattedRating)
                                    .font(.custom("BasisGrotesquePro-Medium", size: 24))
                                    .foregroundColor(Color.pink)
                            }
                        }
                    }
                    .padding(.horizontal)
                    // Остальные секции (программы, категория, задачи, инструкция)
                    // ... (оставить как есть или доработать по макету)
                    // Комментарии
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Комментарии (\(viewModel.comments.count))")
                                .font(.custom("BasisGrotesquePro-Medium", size: 20))
                                .foregroundColor(textColor)
                            Spacer()
                        }
                        ForEach(viewModel.comments.prefix(3)) { comment in
                            CommentCardView(viewModel: comment)
                        }
                        if viewModel.comments.count > 3 {
                            Button(action: { viewModel.loadMoreComments() }) {
                                Text("Загрузить еще")
                                    .font(.custom("BasisGrotesquePro-Medium", size: 17))
                                    .foregroundColor(primaryBlue)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 24)
            } else if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
            } else if let error = viewModel.error {
                VStack {
                    Spacer()
                    Text("Не можем загрузить данные. Проверьте подключение к интернету")
                        .font(.custom("BasisGrotesquePro-Regular", size: 17))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchEffectDetails()
        }
        .sheet(isPresented: $isShareSheetPresented) {
            if let url = URL(string: "https://t.me/efixmedia") {
                ActivityView(activityItems: [url])
            } else {
                ActivityView(activityItems: ["Ссылка недоступна"])
            }
        }
        .sheet(isPresented: $isAddToCollectionPresented) {
            // Заглушка для добавления в коллекцию
            Text("Добавить в коллекцию (заглушка)")
                .font(.title)
                .padding()
        }
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

// Share sheet wrapper
struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}


