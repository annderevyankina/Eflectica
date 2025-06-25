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
    @State private var showAllTop = false
    @State private var showAllMy = false
    @State private var showAllSubs = false
    @State private var selectedCollection: Collection? = nil

    var body: some View {
        Group {
            if let error = viewModel.errorMessage {
                VStack {
                    Spacer()
                    Text("Не можем загрузить данные. Проверьте подключение к интернету")
                        .font(.custom("BasisGrotesquePro-Regular", size: 17))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    Button("Повторить") {
                        if let token = authViewModel.token {
                            viewModel.loadMyCollections(token: token)
                            viewModel.loadSubCollections(token: token)
                        }
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
            } else if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.myCollections.isEmpty && viewModel.favorites.isEmpty && viewModel.subCollections.isEmpty {
                VStack {
                    Spacer()
                    Text("Пока нет коллекций")
                        .font(.custom("BasisGrotesquePro-Regular", size: 17))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    Button("Создать коллекцию") {
                        // TODO: Действие по созданию коллекции
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
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 36) {
                        // Главный заголовок
                        Text("Коллекции")
                            .font(.custom("BasisGrotesquePro-Medium", size: 32))
                            .foregroundColor(Color("PrimaryBlue"))
                            .padding(.horizontal)
                            .padding(.top, 24)
                        // Строка поиска
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color.gray)
                            TextField("Поиск коллекций", text: $viewModel.searchText)
                                .font(.custom("BasisGrotesquePro-Regular", size: 17))
                                .foregroundColor(.black)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                                .background(Color.white.cornerRadius(8))
                        )
                        .padding(.horizontal)
                        // Топовые коллекции (заголовок всегда)
                        Text("Топовые коллекции")
                            .font(.custom("BasisGrotesquePro-Medium", size: 22))
                            .foregroundColor(.black)
                            .padding(.horizontal)
                            .padding(.top, 8)
                        if !viewModel.filteredTopCollections.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(viewModel.filteredTopCollections.prefix(3)) { collection in
                                        CollectionCardView(collection: collection, isFavorite: false, onPlusTap: nil)
                                            .onTapGesture {
                                                selectedCollection = collection
                                            }
                                    }
                                    if viewModel.filteredTopCollections.count > 3 {
                                        Button(action: { showAllTop = true }) {
                                            VStack(spacing: 8) {
                                                Spacer()
                                                Image("moreIcon")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 24, height: 24)
                                                    .foregroundColor(Color("PrimaryBlue"))
                                                Text("Все")
                                                    .font(.custom("BasisGrotesquePro-Medium", size: 17))
                                                    .foregroundColor(Color("PrimaryBlue"))
                                                Spacer()
                                            }
                                            .frame(width: 100, height: 240)
                                            .cornerRadius(12)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        } else {
                            Text("Пока нет топовых коллекций")
                                .font(.custom("BasisGrotesquePro-Regular", size: 16))
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                        }
                        NavigationLink(destination: CollectionsListView(title: "Топовые коллекции", collections: viewModel.filteredTopCollections), isActive: $showAllTop) { EmptyView() }.hidden()
                        // Мои коллекции
                        Text("Мои коллекции")
                            .font(.custom("BasisGrotesquePro-Medium", size: 22))
                            .foregroundColor(.black)
                            .padding(.horizontal)
                            .padding(.top, 8)
                        Button(action: {
                            // TODO: Действие по созданию коллекции
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "plus")
                                    .font(.system(size: 17, weight: .bold))
                                Text("Новая коллекция")
                                    .font(.custom("BasisGrotesquePro-Medium", size: 17))
                            }
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 24)
                            .background(Color("PrimaryBlue"))
                            .cornerRadius(8)
                        }
                        .padding(.horizontal)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                if viewModel.searchText.isEmpty, let favorites = viewModel.favorites.first {
                                    CollectionCardView(collection: favorites, isFavorite: true, onPlusTap: nil)
                                        .onTapGesture {
                                            selectedCollection = favorites
                                        }
                                }
                                ForEach(viewModel.filteredMyCollections.prefix(3)) { collection in
                                    CollectionCardView(collection: collection, isFavorite: false, onPlusTap: nil)
                                        .onTapGesture {
                                            selectedCollection = collection
                                        }
                                }
                                if viewModel.filteredMyCollections.count > 3 {
                                    Button(action: { showAllMy = true }) {
                                        VStack(spacing: 8) {
                                            Spacer()
                                            Image("moreIcon")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 24, height: 24)
                                                .foregroundColor(Color("PrimaryBlue"))
                                            Text("Все")
                                                .font(.custom("BasisGrotesquePro-Medium", size: 17))
                                                .foregroundColor(Color("PrimaryBlue"))
                                            Spacer()
                                        }
                                        .frame(width: 100, height: 240)
                                        .cornerRadius(12)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        NavigationLink(destination: CollectionsListView(title: "Мои коллекции", collections: viewModel.filteredMyCollections), isActive: $showAllMy) { EmptyView() }.hidden()
                        // Подписки (заголовок всегда)
                        Text("Подписки")
                            .font(.custom("BasisGrotesquePro-Medium", size: 22))
                            .foregroundColor(.black)
                            .padding(.horizontal)
                            .padding(.top, 8)
                        if !viewModel.filteredSubCollections.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(viewModel.filteredSubCollections.prefix(3)) { collection in
                                        CollectionCardView(collection: collection, isFavorite: false, onPlusTap: nil)
                                            .onTapGesture {
                                                selectedCollection = collection
                                            }
                                    }
                                    if viewModel.filteredSubCollections.count > 3 {
                                        Button(action: { showAllSubs = true }) {
                                            VStack(spacing: 8) {
                                                Spacer()
                                                Image("moreIcon")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 24, height: 24)
                                                    .foregroundColor(Color("PrimaryBlue"))
                                                Text("Все")
                                                    .font(.custom("BasisGrotesquePro-Medium", size: 17))
                                                    .foregroundColor(Color("PrimaryBlue"))
                                                Spacer()
                                            }
                                            .frame(width: 100, height: 240)
                                            .cornerRadius(12)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        } else {
                            Text("Пока нет подписок")
                                .font(.custom("BasisGrotesquePro-Regular", size: 16))
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                        }
                        NavigationLink(destination: CollectionsListView(title: "Подписки", collections: viewModel.filteredSubCollections), isActive: $showAllSubs) { EmptyView() }.hidden()
                        // Скрытый NavigationLink для перехода к элементам коллекции
                        NavigationLink(
                            destination: Group {
                                if let collection = selectedCollection {
                                    ElementsOfCollectionView(
                                        elements: (collection.effects?.map { .effect($0) } ?? []) +
                                                  (collection.images?.map { .image($0) } ?? []) +
                                                  (collection.links?.map { .link($0) } ?? []),
                                        collectionName: collection.name
                                    )
                                }
                            },
                            isActive: Binding(
                                get: { selectedCollection != nil },
                                set: { isActive in if !isActive { selectedCollection = nil } }
                            )
                        ) { EmptyView() }
                        .hidden()
                    }
                    .padding(.vertical, 8)
                }
                .background(Color(.systemGray6).ignoresSafeArea())
            }
        }
        .onAppear {
            if let token = authViewModel.token {
                viewModel.loadMyCollections(token: token)
                viewModel.loadSubCollections(token: token)
                viewModel.loadAllCollections(token: token)
            }
        }
    }
}
