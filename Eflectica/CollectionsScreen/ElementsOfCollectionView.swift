//
//  ElementsOfCollectionView.swift
//  Eflectica
//
//  Created by Анна on 25.06.2025.
//

import SwiftUI

enum CollectionElement: Identifiable {
    case effect(Effect)
    case image(CollectionImage)
    case link(CollectionLink)
    
    var id: Int {
        switch self {
        case .effect(let effect): return effect.id
        case .image(let image): return image.id
        case .link(let link): return link.id
        }
    }
}

struct ElementsOfCollectionView: View {
    @EnvironmentObject var collectionsViewModel: CollectionsScreenViewModel
    let elements: [CollectionElement]
    let collectionId: Int
    let collectionName: String?
    let user: User?
    var isMy: Bool = false
    var onAddElement: (() -> Void)? = nil
    var onEdit: (() -> Void)? = nil
    var onDelete: (() -> Void)? = nil
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showShareSheet = false
    private let defaultShareUrl = "https://t.me/efixmedia"
    @State private var selectedEffectId: Int? = nil
    @State private var showElementDetail = false
    @State private var selectedElement: CollectionElement? = nil
    
    var body: some View {
        ZStack {
            Color("LightGrey").ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Заголовок коллекции
                    if let collectionName = collectionName {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(alignment: .center, spacing: 8) {
                                Text(collectionName)
                                    .font(.custom("BasisGrotesquePro-Medium", size: 28))
                                    .foregroundColor(Color("PrimaryBlue"))
                                    .lineLimit(2)
                                    .fixedSize(horizontal: false, vertical: true)
                                Button(action: { onEdit?() }) {
                                    Image("editIcon")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 12)
                            // Кнопки "Добавить элемент" и "Поделиться"
                            HStack(spacing: 12) {
                                Button(action: { onAddElement?() }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "plus")
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(.white)
                                        Text("Добавить элемент")
                                    }
                                    .font(.custom("BasisGrotesquePro-Medium", size: 17))
                                    .foregroundColor(.white)
                                    .frame(height: 48)
                                    .padding(.horizontal, 20)
                                    .background(Color("PrimaryBlue"))
                                    .cornerRadius(8)
                                }
                                Button(action: { showShareSheet = true }) {
                                    ZStack {
                                        Color.white
                                        Image("shareIcon")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 22, height: 22)
                                    }
                                    .frame(width: 48, height: 48)
                                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color("Grey"), lineWidth: 1.5))
                                    .cornerRadius(8)
                                }
                                .sheet(isPresented: $showShareSheet) {
                                    if let url = URL(string: defaultShareUrl) {
                                        ShareActivityView(activityItems: [url])
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    // Эффекты
                    let effectElements = elements.filter { if case .effect = $0 { return true } else { return false } }
                    if !effectElements.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Эффекты")
                                .font(.custom("BasisGrotesquePro-Medium", size: 22))
                                .foregroundColor(.black)
                                .padding(.horizontal)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(effectElements.prefix(3)) { element in
                                        if case .effect(let effect) = element {
                                            Button(action: { selectedEffectId = effect.id }) {
                                                EffectCardViewWithProgram(effect: effect)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                    if effectElements.count > 3 {
                                        Button(action: {}) {
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
                                            .frame(width: 100, height: 209)
                                            .cornerRadius(12)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    // Референсы
                    let imageElements = elements.filter { if case .image = $0 { return true } else { return false } }
                    if !imageElements.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Референсы")
                                .font(.custom("BasisGrotesquePro-Medium", size: 22))
                                .foregroundColor(.black)
                                .padding(.horizontal)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(imageElements.prefix(3)) { element in
                                        if case .image(let image) = element {
                                            CollectionImageCardView_Mockup(image: image)
                                                .onTapGesture {
                                                    selectedElement = .image(image)
                                                    showElementDetail = true
                                                }
                                        }
                                    }
                                    if imageElements.count > 3 {
                                        Button(action: {}) {
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
                                            .frame(width: 100, height: 209)
                                            .cornerRadius(12)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    // Ссылки
                    let linkElements = elements.filter { if case .link = $0 { return true } else { return false } }
                    if !linkElements.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Ссылки")
                                .font(.custom("BasisGrotesquePro-Medium", size: 22))
                                .foregroundColor(.black)
                                .padding(.horizontal)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(linkElements.prefix(3)) { element in
                                        if case .link(let link) = element {
                                            CollectionLinkCardView(link: link)
                                                .onTapGesture {
                                                    selectedElement = .link(link)
                                                    showElementDetail = true
                                                }
                                        }
                                    }
                                    if linkElements.count > 3 {
                                        Button(action: {}) {
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
                                            .frame(width: 100, height: 80)
                                            .cornerRadius(12)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }

                    if let onDelete = onDelete {
                        Button(action: onDelete) {
                            Text("Удалить коллекцию")
                                .font(.custom("BasisGrotesquePro-Medium", size: 17))
                                .foregroundColor(Color("DangerColor"))
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color("DangerColor"), lineWidth: 1.5)
                                )
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        .padding(.bottom, 24)
                    }
                }
                .padding(.bottom, 16)
            }
            NavigationLink(
                destination: Group {
                    if let effectId = selectedEffectId {
                        EffectDetailView(
                            effectId: effectId,
                            user: user,
                            token: authViewModel.token
                        )
                        .environmentObject(collectionsViewModel)
                    }
                },
                isActive: Binding(
                    get: { selectedEffectId != nil },
                    set: { isActive in if !isActive { selectedEffectId = nil } }
                )
            ) { EmptyView() }
            .hidden()
            // Модалка для просмотра/удаления элемента
            .sheet(isPresented: $showElementDetail) {
                if let selectedElement = selectedElement {
                    ElementDetailView(
                        type: {
                            switch selectedElement {
                            case .link(let link): return .link(link)
                            case .image(let image): return .reference(image)
                            default: fatalError("Not supported")
                            }
                        }(),
                        collectionId: collectionId,
                        isOwner: isMy,
                        onDeleteSuccess: {
                            // После удаления обновить коллекцию
                            if let token = authViewModel.token {
                                collectionsViewModel.loadMyCollections(token: token)
                            }
                        }
                    )
                    .environmentObject(collectionsViewModel)
                    .environmentObject(authViewModel)
                }
            }
        }
    }
}

// MARK: - Карточка эффекта
struct EffectCardViewWithProgram: View {
    let effect: Effect
    var body: some View {
        let programs = effect.programs ?? effect.programsWithVersions
        VStack(spacing: 0) {
            EffectCardView(
                id: effect.id,
                images: [effect.img.q70?.url ?? effect.img.url, effect.beforeImage?.q70?.url ?? effect.beforeImage?.url ?? ""],
                name: effect.name,
                programs: programs?.map { $0.name } ?? [],
                rating: 0,
                isTopEffect: false,
                isFullWidth: false
            )
        }
        .frame(width: 260)
    }
}

// MARK: - Карточка 
struct CollectionImageCardView_Mockup: View {
    let image: CollectionImage
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AsyncImage(url: URL(string: image.imageUrl ?? image.file.q70?.url ?? image.file.url)) { img in
                img
                    .resizable()
                    .scaledToFill()
                    .frame(width: 260, height: 150)
                    .clipped()
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 260, height: 150)
            }
            Text(image.title ?? "")
                .font(.custom("BasisGrotesquePro-Medium", size: 16))
                .foregroundColor(.black)
                .lineLimit(1)
                .padding(.top, 8)
                .padding(.horizontal, 12)
            Spacer()
        }
        .frame(width: 260, height: 209)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color("Grey"), lineWidth: 2)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Карточка рефа
struct CollectionImageCardView: View {
    let image: CollectionImage
    var body: some View {
        HStack(spacing: 12) {
            // Изображение
            AsyncImage(url: URL(string: image.imageUrl ?? image.file.q70?.url ?? image.file.url)) { img in
                img
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipped()
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 80, height: 80)
            }
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(image.title ?? "Изображение")
                    .font(.custom("BasisGrotesquePro-Medium", size: 16))
                    .foregroundColor(.black)
                    .lineLimit(2)
                
                Text("Изображение")
                    .font(.custom("BasisGrotesquePro-Regular", size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Иконка
            Image(systemName: "photo")
                .font(.system(size: 20))
                .foregroundColor(.gray)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.12), lineWidth: 1)
        )
    }
}

// MARK: - Карточка ссылки
struct CollectionLinkCardView: View {
    let link: CollectionLink
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 40, height: 40)
                Image(systemName: "link")
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("Ссылка")
                    .font(.custom("BasisGrotesquePro-Medium", size: 16))
                    .foregroundColor(.black)
                Text(link.path)
                    .font(.custom("BasisGrotesquePro-Regular", size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            Spacer()
            Image(systemName: "arrow.up.right")
                .font(.system(size: 16))
                .foregroundColor(.gray)
        }
        .padding(16)
        .frame(width: 260, height: 80)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color("Grey"), lineWidth: 2)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

func extractProgramsWithVersions(from effect: Effect) -> [EffectProgram]? {
    let mirror = Mirror(reflecting: effect)
    if let child = mirror.children.first(where: { $0.label == "programs_with_versions" }),
       let value = child.value as? [[String: Any]] {
        return value.compactMap { dict in
            guard let name = dict["name"] as? String, let version = dict["version"] as? String else { return nil }
            return EffectProgram(name: name, version: version)
        }
    }
    return nil
}

