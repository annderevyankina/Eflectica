//
//  CommentCardView.swift
//  Eflectica
//
//  Created by Анна on 24.06.2025.
//

import SwiftUI

struct CommentCardView: View {
    let viewModel: CommentCardViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                AsyncImage(url: URL(string: viewModel.avatarUrl)) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Circle().fill(Color.gray.opacity(0.2))
                }
                .frame(width: 32, height: 32)
                .clipShape(Circle())

                VStack(alignment: .leading, spacing: 2) {
                    Text("@\(viewModel.username)")
                        .font(.custom("BasisGrotesquePro-Regular", size: 15))
                }
                Spacer()
                Text(viewModel.dateString)
                    .font(.custom("BasisGrotesquePro-Regular", size: 13))
                    .foregroundColor(Color.gray)
            }
            Text(viewModel.text)
                .font(.custom("BasisGrotesquePro-Regular", size: 15))
            Button(action: { /* Ответить */ }) {
                Text("Ответить")
                    .font(.custom("BasisGrotesquePro-Regular", size: 15))
                    .foregroundColor(Color.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
    }
}

