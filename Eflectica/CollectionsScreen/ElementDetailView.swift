//
//  ElementDetailView.swift
//  Eflectica
//
//  Created by Анна on 26.06.2025.
//

import SwiftUI

enum ElementDetailType {
    case link(CollectionLink)
    case reference(CollectionImage)
}

struct ElementDetailView: View {
    let type: ElementDetailType
    let collectionId: Int
    let isOwner: Bool
    let onDeleteSuccess: () -> Void
    @EnvironmentObject var collectionsViewModel: CollectionsScreenViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showDeleteAlert = false
    @State private var isDeleting = false
    @State private var deleteError: String? = nil
    @State private var notes: String = ""
    @State private var linkValue: String = ""
    @State private var isEditing = false

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Text(type.headerTitle)
                    .font(.custom("BasisGrotesquePro-Medium", size: 18))
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .truncationMode(.tail)
                if case .reference = type, isOwner {
                    Button(action: { /* edit action */ }) {
                        Image(systemName: "pencil")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color("PrimaryBlue"))
                    }
                }
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(.black)
                        .padding(8)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 0)
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    switch type {
                    case .reference(let image):
                        Text("Референс")
                            .font(.custom("BasisGrotesquePro-Medium", size: 16))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        let urlString = image.imageUrl ?? image.file.q70?.url ?? image.file.url
                        if !urlString.isEmpty, let url = URL(string: urlString) {
                            AsyncImage(url: url) { img in
                                img.resizable().scaledToFill()
                            } placeholder: {
                                Rectangle().fill(Color.gray.opacity(0.2))
                            }
                            .frame(height: 90)
                            .clipped()
                            .cornerRadius(12)
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                        } else {
                            Rectangle().fill(Color.gray.opacity(0.2))
                                .frame(height: 90)
                                .cornerRadius(12)
                                .padding(.horizontal, 20)
                                .padding(.top, 8)
                        }
                        Text(image.title ?? "")
                            .font(.custom("BasisGrotesquePro-Medium", size: 15))
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        if isOwner {
                            Button(action: { showDeleteAlert = true }) {
                                Text("Удалить референс")
                                    .font(.custom("BasisGrotesquePro-Medium", size: 15))
                                    .foregroundColor(Color("DangerColor"))
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .padding(.top, 8)
                                    .padding(.trailing, 20)
                            }
                        }
                    case .link(let link):
                        Text("Ссылка")
                            .font(.custom("BasisGrotesquePro-Medium", size: 16))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("Заметки", text: $notes)
                            .font(.custom("BasisGrotesquePro-Regular", size: 15))
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color("LightGrey"), lineWidth: 1)
                            )
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                        HStack(spacing: 8) {
                            Image(systemName: "link")
                                .foregroundColor(Color("PrimaryBlue"))
                            Text(link.path)
                                .font(.custom("BasisGrotesquePro-Regular", size: 15))
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .lineLimit(1)
                                .truncationMode(.middle)
                        }
                        .padding(8)
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color("LightGrey"), lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        if isOwner {
                            Button(action: { showDeleteAlert = true }) {
                                Text("Удалить ссылку")
                                    .font(.custom("BasisGrotesquePro-Medium", size: 15))
                                    .foregroundColor(Color("DangerColor"))
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .padding(.top, 8)
                                    .padding(.trailing, 20)
                            }
                        }
                    }
                }
            }
            .alert("Точно хочешь удалить?", isPresented: $showDeleteAlert) {
                Button("Удалить", role: .destructive) { deleteElement() }
                Button("Отмена", role: .cancel) { }
            } message: {
                if let err = deleteError {
                    Text(err)
                }
            }
        }
        .background(Color.white)
        .cornerRadius(20)
        .padding(.vertical, 20)
        .padding(.horizontal, 8)
        .frame(maxHeight: UIScreen.main.bounds.height * 0.5)
        .onAppear {
            if case .link(let link) = type {
                linkValue = link.path
            }
        }
    }

    private func deleteElement() {
        guard let token = authViewModel.token else { return }
        isDeleting = true
        deleteError = nil
        switch type {
        case .link(let link):
            collectionsViewModel.worker.deleteLink(token: token, collectionId: collectionId, linkId: link.id) { result in
                DispatchQueue.main.async {
                    isDeleting = false
                    switch result {
                    case .success:
                        onDeleteSuccess()
                        dismiss()
                    case .failure(let error):
                        deleteError = error.localizedDescription
                    }
                }
            }
        case .reference(let image):
            collectionsViewModel.worker.deleteImage(token: token, collectionId: collectionId, imageId: image.id) { result in
                DispatchQueue.main.async {
                    isDeleting = false
                    switch result {
                    case .success:
                        onDeleteSuccess()
                        dismiss()
                    case .failure(let error):
                        deleteError = error.localizedDescription
                    }
                }
            }
        }
    }
}

private extension ElementDetailType {
    var headerTitle: String {
        switch self {
        case .link: return "Ссылка"
        case .reference: return "Референс"
        }
    }
}

