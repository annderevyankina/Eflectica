//
//  EffectDetailView.swift
//  Eflectica
//
//  Created by Анна on 21.05.2025.
//

import SwiftUI
import UIKit
import Foundation
import Eflectica

struct EffectDetailView: View {
    @StateObject var viewModel: EffectDetailViewModel
    let user: User?
    @State private var isShareSheetPresented = false
    @State private var isAddToCollectionPresented = false
    @State private var commentText: String = ""
    @State private var showAllComments = false
    
    private let primaryBlue = Color("PrimaryBlue")
    private let darkGrey = Color("DarkGrey")
    private let dangerColor = Color("DangerColor")
    private let textColor = Color("TextColor")
    private let tagGrey = Color("Grey")
    private let pinkColor = Color("PinkColor")
    
    var body: some View {
        ZStack {
            Color("LightGrey").ignoresSafeArea()
            ScrollView {
                if let effectCard = viewModel.effectCard {
                    VStack(alignment: .center, spacing: 0) {
                        // Заголовок
                        Text(effectCard.name)
                            .font(.custom("BasisGrotesquePro-Medium", size: 28))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding(.top, 24)
                            .padding(.bottom, 16)
                            .frame(maxWidth: .infinity)
                        
                        // Блок до/после
                        VStack(spacing: 16) {
                            VStack(spacing: 6) {
                                EffectImageView(url: effectCard.beforeImageUrl)
                                    .frame(height: 198)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                Text("До применения")
                                    .font(.custom("BasisGrotesquePro-Regular", size: 15))
                                    .foregroundColor(darkGrey)
                            }
                            VStack(spacing: 6) {
                                EffectImageView(url: effectCard.afterImageUrl)
                                    .frame(height: 198)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                Text("После применения")
                                    .font(.custom("BasisGrotesquePro-Regular", size: 15))
                                    .foregroundColor(darkGrey)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 20)
                        
                        // Описание
                        if !effectCard.description.isEmpty {
                            Text(effectCard.description)
                                .font(.custom("BasisGrotesquePro-Regular", size: 17))
                                .foregroundColor(textColor)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 24)
                                .padding(.bottom, 20)
                        }
                        
                        // Кнопки
                        HStack(spacing: 12) {
                            Button(action: { /* TODO: логика установки */ }) {
                                Text("Установить")
                                    .font(.custom("BasisGrotesquePro-Medium", size: 17))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 48)
                                    .background(primaryBlue)
                                    .cornerRadius(6)
                            }
                            Button(action: { /* TODO: заглушка */ }) {
                                ZStack {
                                    Color.white
                                    Image("plusIcon")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 22, height: 22)
                                }
                                .frame(width: 48, height: 48)
                                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color("Grey"), lineWidth: 2))
                                .cornerRadius(6)
                            }
                            Button(action: {
                                if let url = viewModel.effectCard?.manual, let shareUrl = URL(string: url) {
                                    let av = UIActivityViewController(activityItems: [shareUrl], applicationActivities: nil)
                                    UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true)
                                }
                            }) {
                                ZStack {
                                    Color.white
                                    Image("shareIcon")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 22, height: 22)
                                }
                                .frame(width: 48, height: 48)
                                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color("Grey"), lineWidth: 2))
                                .cornerRadius(6)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 20)
                        
                        // Автор и рейтинг
                        HStack(alignment: .center, spacing: 24) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Автор эффекта")
                                    .font(.custom("BasisGrotesquePro-Medium", size: 17))
                                    .foregroundColor(textColor)
                                HStack(spacing: 12) {
                                    EffectAvatarView(url: effectCard.authorAvatarUrl)
                                        .frame(width: 56, height: 56)
                                    Text("@" + effectCard.authorUsername)
                                        .font(.custom("BasisGrotesquePro-Medium", size: 15))
                                        .foregroundColor(Color.gray)
                                }
                            }
                            Spacer()
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("Рейтинг")
                                    .font(.custom("BasisGrotesquePro-Medium", size: 17))
                                    .foregroundColor(textColor)
                                HStack(spacing: 4) {
                                    Image("starIcon")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                    Text(effectCard.formattedRating)
                                        .font(.custom("BasisGrotesquePro-Medium", size: 24))
                                        .foregroundColor(pinkColor)
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 20)
                        
                        // Программы (убрать systemName-иконки, оставить только ассетные)
                        if !effectCard.programs.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Подойдет для")
                                    .font(.custom("BasisGrotesquePro-Medium", size: 17))
                                    .foregroundColor(textColor)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(Program.findByIds(effectCard.programs), id: \ .id) { program in
                                        HStack(spacing: 12) {
                                            Image(program.iconName)
                                                .resizable()
                                                .frame(width: 32, height: 32)
                                            Text(program.name)
                                                .font(.custom("BasisGrotesquePro-Regular", size: 16))
                                                .foregroundColor(textColor)
                                        }
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 24)
                            .padding(.bottom, 20)
                        }
                        
                        // Категория
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Категория")
                                .font(.custom("BasisGrotesquePro-Medium", size: 17))
                                .foregroundColor(textColor)
                                .padding(.bottom, 0)
                            if let firstCategory = effectCard.categoryList.first {
                                NavigationLink(destination: CategoryView(category: Category(id: firstCategory, name: categoryDescriptions[firstCategory] ?? firstCategory), effects: [])) {
                                    HStack(spacing: 6) {
                                        Text(categoryDescriptions[firstCategory] ?? firstCategory)
                                            .font(.custom("BasisGrotesquePro-Medium", size: 17))
                                            .foregroundColor(Color("PrimaryBlue"))
                                            .fixedSize(horizontal: true, vertical: false)
                                        Image("moreIcon")
                                            .resizable()
                                            .frame(width: 18, height: 18)
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 20)
                        
                        // Задачи
                        if let tasks = effectCard.tasks, !tasks.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Задачи")
                                    .font(.custom("BasisGrotesquePro-Medium", size: 17))
                                    .foregroundColor(textColor)
                                
                                FlexibleTagsView(tasks: tasks, taskDescriptions: taskDescriptions)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 24)
                            .padding(.bottom, 20)
                        }
                        
                        // Инструкция по использованию
                        if let manual = effectCard.manual, !manual.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Инструкция по использованию")
                                    .font(.custom("BasisGrotesquePro-Medium", size: 17))
                                    .foregroundColor(textColor)
                                
                                ForEach(manual.split(separator: "\n").enumerated().map({ $0 }), id: \.offset) { idx, step in
                                    HStack(alignment: .top, spacing: 8) {
                                        Text(step.trimmingCharacters(in: .whitespacesAndNewlines))
                                            .font(.custom("BasisGrotesquePro-Regular", size: 15))
                                            .foregroundColor(textColor)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 24)
                            .padding(.bottom, 20)
                        }
                        
                        // Комментарии
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Комментарии (" + String(viewModel.comments.count) + ")")
                                .font(.custom("BasisGrotesquePro-Medium", size: 18))
                                .foregroundColor(textColor)
                            ForEach(showAllComments ? viewModel.comments : Array(viewModel.comments.prefix(3))) { comment in
                                CommentCardView(viewModel: comment)
                            }
                            if viewModel.comments.count > 3 && !showAllComments {
                                Button(action: { showAllComments = true }) {
                                    Text("Загрузить еще")
                                        .font(.custom("BasisGrotesquePro-Medium", size: 16))
                                        .foregroundColor(primaryBlue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                            }
                            HStack(spacing: 12) {
                                // Аватар
                                if let avatarUrl = user?.avatar?.q70?.url ?? user?.avatar?.url, !avatarUrl.isEmpty {
                                    AsyncImage(url: URL(string: avatarUrl)) { image in
                                        image.resizable().aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        Circle().fill(Color.gray.opacity(0.2))
                                    }
                                    .frame(width: 36, height: 36)
                                    .clipShape(Circle())
                                } else {
                                    Image("default_avatar")
                                        .resizable()
                                        .frame(width: 36, height: 36)
                                        .clipShape(Circle())
                                }
                                // Поле ввода
                                TextField("Напиши комментарий или поставь оценку", text: $commentText)
                                    .font(.custom("BasisGrotesquePro-Regular", size: 16))
                                // Кнопка отправки
                                Button(action: {
                                    commentText = ""
                                }) {
                                    Image(commentText.isEmpty ? "sendIcon" : "sendIconActive")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 22, height: 22)
                                }
                            }
                            .frame(height: 48)
                            .padding(.horizontal, 12)
                            .background(Color.white)
                            .cornerRadius(6)
                            .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 32)
                    }
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
                        
                        Button("Повторить") {
                            viewModel.fetchEffectDetails()
                        }
                        .font(.custom("BasisGrotesquePro-Medium", size: 17))
                        .foregroundColor(.white)
                        .frame(height: 48)
                        .frame(maxWidth: 220)
                        .background(primaryBlue)
                        .cornerRadius(8)
                        .padding(.top, 16)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchEffectDetails()
        }
        .sheet(isPresented: $isAddToCollectionPresented) {
            Text("Добавить в коллекцию (заглушка)")
                .font(.title)
                .padding()
        }
        .sheet(isPresented: $isShareSheetPresented) {
            if let url = URL(string: "https://t.me/efixmedia") {
                ActivityView(activityItems: [url])
            } else {
                ActivityView(activityItems: ["Ссылка недоступна"])
            }
        }
    }
}

struct EffectImageView: View {
    let url: String?
    
    var body: some View {
        if let url = url, let imageURL = URL(string: url) {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill)
                case .failure:
                    Rectangle().fill(Color(.systemGray5))
                @unknown default:
                    Rectangle().fill(Color(.systemGray5))
                }
            }
        } else {
            Rectangle().fill(Color(.systemGray5))
        }
    }
}

struct EffectAvatarView: View {
    let url: String?
    
    var body: some View {
        if let url = url, let imageURL = URL(string: url) {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 32, height: 32)
                case .success(let image):
                    image.resizable().scaledToFill()
                        .clipShape(Circle())
                case .failure:
                    Image("default_avatar")
                        .resizable().scaledToFill()
                        .clipShape(Circle())
                @unknown default:
                    Image("default_avatar")
                        .resizable().scaledToFill()
                        .clipShape(Circle())
                }
            }
        } else {
            Image("default_avatar")
                .resizable().scaledToFill()
                .clipShape(Circle())
        }
    }
}

struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct FlexibleTagsView: View {
    let tasks: [String]
    let taskDescriptions: [String: String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            let rows = organizeTasksIntoRows(availableWidth: UIScreen.main.bounds.width - 48)
            ForEach(rows.indices, id: \.self) { rowIndex in
                HStack(alignment: .center, spacing: 8) {
                    ForEach(rows[rowIndex], id: \.self) { taskId in
                        Text(taskDescriptions[taskId] ?? taskId)
                            .font(.custom("BasisGrotesquePro-Regular", size: 16))
                            .foregroundColor(.black)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color("Grey"))
                            .cornerRadius(8)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                    Spacer()
                }
            }
        }
    }
    
    private func organizeTasksIntoRows(availableWidth: CGFloat) -> [[String]] {
        var rows: [[String]] = []
        var currentRow: [String] = []
        var currentRowWidth: CGFloat = 0
        let horizontalSpacing: CGFloat = 8
        let horizontalPadding: CGFloat = 48 // 24 + 24 padding
        let effectiveWidth = availableWidth - horizontalPadding
        
        for taskId in tasks {
            let taskText = taskDescriptions[taskId] ?? taskId
            let tagWidth = estimateTagWidth(for: taskText)
            
            // Проверяем, поместится ли тег в текущую строку
            let widthWithSpacing = currentRowWidth + (currentRow.isEmpty ? 0 : horizontalSpacing) + tagWidth
            
            if widthWithSpacing <= effectiveWidth && !currentRow.isEmpty {
                // Помещается в текущую строку
                currentRow.append(taskId)
                currentRowWidth = widthWithSpacing
            } else {
                // Не помещается, начинаем новую строку
                if !currentRow.isEmpty {
                    rows.append(currentRow)
                }
                currentRow = [taskId]
                currentRowWidth = tagWidth
            }
        }
        
        // Добавляем последнюю строку
        if !currentRow.isEmpty {
            rows.append(currentRow)
        }
        
        return rows
    }
    
    private func estimateTagWidth(for text: String) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 16, weight: .regular)
        let attributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: attributes)
        return size.width + 24 // 12 + 12 horizontal padding
    }
}



