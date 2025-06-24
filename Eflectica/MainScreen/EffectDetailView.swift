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
    @State private var commentText: String = ""
    @State private var showAllComments = false
    
    private let primaryBlue = Color("PrimaryBlue")
    private let darkGrey = Color("DarkGrey")
    private let dangerColor = Color("DangerColor")
    private let textColor = Color("TextColor")
    private let tagGrey = Color("Grey")
    private let pinkColor = Color("PinkColor")
    
    var body: some View {
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
                                .frame(height: 160)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            Text("До применения")
                                .font(.custom("BasisGrotesquePro-Regular", size: 15))
                                .foregroundColor(darkGrey)
                        }
                        VStack(spacing: 6) {
                            EffectImageView(url: effectCard.afterImageUrl)
                                .frame(height: 160)
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
                        Button(action: { /* твоя логика установки */ }) {
                            HStack {
                                Image(systemName: "arrow.down.to.line.alt")
                                Text("Установить")
                            }
                            .font(.custom("BasisGrotesquePro-Medium", size: 17))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(primaryBlue)
                            .cornerRadius(8)
                        }
                        Button(action: { isAddToCollectionPresented = true }) {
                            Image(systemName: "plus")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 22, height: 22)
                                .foregroundColor(primaryBlue)
                                .padding(12)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(primaryBlue, lineWidth: 2)
                                )
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                    // Автор
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Автор эффекта")
                            .font(.custom("BasisGrotesquePro-Medium", size: 15))
                            .foregroundColor(textColor)
                        HStack(spacing: 8) {
                            EffectAvatarView(url: effectCard.authorAvatarUrl)
                                .frame(width: 32, height: 32)
                            Text("@" + effectCard.authorUsername)
                                .font(.custom("BasisGrotesquePro-Regular", size: 16))
                                .foregroundColor(darkGrey)
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                    // Рейтинг
                    if effectCard.averageRating > 0 {
                        HStack {
                            Spacer()
                            HStack(spacing: 4) {
                                Image("starIcon")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Text(effectCard.formattedRating)
                                    .font(.custom("BasisGrotesquePro-Medium", size: 22))
                                    .foregroundColor(pinkColor)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 20)
                    }
                    // Категория (только первая)
                    if let firstCategoryId = effectCard.categoryList.first,
                       let categoryName = categoryDescriptions[firstCategoryId] {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Категория")
                                .font(.custom("BasisGrotesquePro-Medium", size: 15))
                                .foregroundColor(textColor)
                            NavigationLink(value: CategoryRoute.category(category: Category(id: firstCategoryId, name: categoryName))) {
                                HStack(spacing: 6) {
                                    Text(categoryName)
                                        .font(.custom("BasisGrotesquePro-Regular", size: 15))
                                        .foregroundColor(primaryBlue)
                                    Image("moreIcon")
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                        .foregroundColor(primaryBlue)
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 8)
                    }
                    // Задачи (все)
                    if !effectCard.categoryList.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Задачи")
                                .font(.custom("BasisGrotesquePro-Medium", size: 15))
                                .foregroundColor(textColor)
                            WrapHStack(items: effectCard.categoryList) { taskId in
                                Group {
                                    if let task = allTasks.first(where: { $0.id == taskId }) {
                                        Text(task.title)
                                            .font(.custom("BasisGrotesquePro-Regular", size: 14))
                                            .foregroundColor(primaryBlue)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 4)
                                            .background(tagGrey)
                                            .cornerRadius(6)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 20)
                    }
                    // Программы (все)
                    if !effectCard.programs.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Подходит для")
                                .font(.custom("BasisGrotesquePro-Medium", size: 16))
                                .foregroundColor(darkGrey)
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(effectCard.programs, id: \ .self) { programId in
                                    if let programInfo = Program.all.first(where: { $0.id == programId }) {
                                        HStack(spacing: 8) {
                                            Image(programInfo.iconName)
                                                .resizable()
                                                .frame(width: 24, height: 24)
                                            Text("\(programInfo.name) и выше")
                                                .font(.custom("BasisGrotesquePro-Regular", size: 15))
                                                .foregroundColor(textColor)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 20)
                    }
                    // Инструкция
                    if let manual = effectCard.manual, !manual.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Инструкция по использованию")
                                .font(.custom("BasisGrotesquePro-Medium", size: 15))
                                .foregroundColor(textColor)
                            ForEach(manual.split(separator: "\n").enumerated().map({ $0 }), id: \ .offset) { idx, step in
                                HStack(alignment: .top, spacing: 8) {
                                    Text("\(idx+1).")
                                        .font(.custom("BasisGrotesquePro-Medium", size: 15))
                                        .foregroundColor(primaryBlue)
                                        .padding(.top, 2)
                                    Text(step.trimmingCharacters(in: .whitespacesAndNewlines))
                                        .font(.custom("BasisGrotesquePro-Regular", size: 15))
                                        .foregroundColor(textColor)
                                }
                            }
                        }
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
                        }
                        // Форма для нового комментария
                        HStack(alignment: .center, spacing: 8) {
                            TextField("Напиши комментарий или поставь оценку", text: $commentText)
                                .font(.custom("BasisGrotesquePro-Regular", size: 15))
                                .padding(12)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            Button(action: {
                                // TODO: Реализовать отправку комментария через viewModel
                                commentText = ""
                            }) {
                                Image(systemName: "paperplane.fill")
                                    .foregroundColor(primaryBlue)
                                    .font(.system(size: 20))
                            }
                        }
                    }
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

// MARK: - Вспомогательные вью

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

struct WrapHStack<Item: Hashable, Content: View>: View {
    let items: [Item]
    let content: (Item) -> Content
    @State private var totalHeight = CGFloat.zero
    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
        .frame(height: totalHeight)
    }
    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        return ZStack(alignment: .topLeading) {
            ForEach(items, id: \ .self) { item in
                content(item)
                    .padding([.horizontal, .vertical], 2)
                    .alignmentGuide(.leading, computeValue: { d in
                        if abs(width - d.width) > g.size.width {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if item == items.last {
                            width = 0 // last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { _ in
                        let result = height
                        if item == items.last {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }
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


