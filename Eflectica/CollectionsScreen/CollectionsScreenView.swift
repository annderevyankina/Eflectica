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
    @EnvironmentObject var profileViewModel: ProfileScreenViewModel
    @State private var showAuth = false
    @State private var showAllTop = false
    @State private var showAllMy = false
    @State private var showAllSubs = false
    @State private var selectedCollection: Collection? = nil

    var body: some View {
        VStack {
            if let _ = viewModel.errorMessage {
                errorView
            } else if !authViewModel.isAuthorized {
                authView
            } else if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.myCollections.isEmpty && viewModel.favorites.isEmpty && viewModel.subCollections.isEmpty {
                emptyView
            } else {
                mainContentView
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

    private var errorView: some View {
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
    }

    private var authView: some View {
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
    }

    private var emptyView: some View {
        VStack {
            Spacer()
            Text("Пока нет коллекций")
                .font(.custom("BasisGrotesquePro-Regular", size: 17))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            Button("Создать коллекцию") {
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
    }

    private var mainContentView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                headerSection
                searchSection
                topCollectionsSection
                myCollectionsSection
                subCollectionsSection
                navigationLinksSection
            }
            .padding(.vertical, 8)
        }
        .background(Color(.systemGray6).ignoresSafeArea())
    }

    private var headerSection: some View {
        Text("Коллекции")
            .font(.custom("BasisGrotesquePro-Medium", size: 32))
            .foregroundColor(Color("PrimaryBlue"))
            .padding(.horizontal)
            .padding(.top, 24)
    }

    private var searchSection: some View {
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
    }

    private var topCollectionsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Топовые коллекции")
                .font(.custom("BasisGrotesquePro-Medium", size: 22))
                .foregroundColor(.black)
                .padding(.horizontal)
                .padding(.top, 2)
            if !viewModel.filteredTopCollections.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.filteredTopCollections.prefix(3)) { collection in
                            CollectionCardView(collection: collection, type: .top, onPlusTap: nil)
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
                .padding(.bottom, 8)
            } else {
                Text("Пока нет топовых коллекций")
                    .font(.custom("BasisGrotesquePro-Regular", size: 16))
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            }
        }
    }

    private var myCollectionsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Мои коллекции")
                .font(.custom("BasisGrotesquePro-Medium", size: 22))
                .foregroundColor(.black)
                .padding(.horizontal)
                .padding(.top, 2)
            Button(action: {
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
            if !viewModel.filteredMyCollections.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.filteredMyCollections) { collection in
                            CollectionCardView(collection: collection, type: .my, onPlusTap: nil)
                                .onTapGesture {
                                    selectedCollection = collection
                                }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 8)
            }
        }
    }

    private var subCollectionsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Подписки")
                .font(.custom("BasisGrotesquePro-Medium", size: 22))
                .foregroundColor(.black)
                .padding(.horizontal)
                .padding(.top, 2)
            if !viewModel.filteredSubCollections.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.filteredSubCollections) { collection in
                            CollectionCardView(collection: collection, type: .sub, onPlusTap: nil)
                                .onTapGesture {
                                    selectedCollection = collection
                                }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 8)
            } else {
                Text("Пока нет подписок")
                    .font(.custom("BasisGrotesquePro-Regular", size: 16))
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            }
        }
    }

    private var navigationLinksSection: some View {
        Group {
            topCollectionsLink
            myCollectionsLink
            subCollectionsLink
            elementDetailLink
        }
    }

    private var topCollectionsLink: some View {
        NavigationLink(
            destination: CollectionsListView(
                title: "Топовые коллекции",
                collections: viewModel.filteredTopCollections,
                user: profileViewModel.user
            ),
            isActive: $showAllTop
        ) { EmptyView() }.hidden()
    }

    private var myCollectionsLink: some View {
        NavigationLink(
            destination: CollectionsListView(
                title: "Мои коллекции",
                collections: viewModel.filteredMyCollections,
                user: profileViewModel.user
            ),
            isActive: $showAllMy
        ) { EmptyView() }.hidden()
    }

    private var subCollectionsLink: some View {
        NavigationLink(
            destination: CollectionsListView(
                title: "Подписки",
                collections: viewModel.filteredSubCollections,
                user: profileViewModel.user
            ),
            isActive: $showAllSubs
        ) { EmptyView() }.hidden()
    }

    private func elements(for collection: Collection) -> [CollectionElement] {
        (collection.effects?.map { .effect($0) } ?? []) +
        (collection.images?.map { .image($0) } ?? []) +
        (collection.links?.map { .link($0) } ?? [])
    }

    private var elementDetailDestination: some View {
        Group {
            if let collection = selectedCollection {
                ElementsOfCollectionView(
                    elements: elements(for: collection),
                    collectionId: collection.id,
                    collectionName: collection.name,
                    user: profileViewModel.user
                )
                .environmentObject(viewModel)
            }
        }
    }

    private var elementDetailLink: some View {
        NavigationLink(
            destination: elementDetailDestination,
            isActive: Binding(
                get: { selectedCollection != nil },
                set: { isActive in if !isActive { selectedCollection = nil } }
            )
        ) { EmptyView() }.hidden()
    }
}
