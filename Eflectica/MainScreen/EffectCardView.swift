//
//  EffectCardView.swift
//  Eflectica
//
//  Created by Анна on 21.05.2025.
//

import SwiftUI

private let greyColor = Color("Grey")

struct EffectCardView: View {
    let images: [String]         
    let title: String
    let tags: [String]
    let rating: Double?
    let showRating: Bool

    @State private var selectedImage = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Слайдер изображений
            TabView(selection: $selectedImage) {
                ForEach(images.indices, id: \.self) { index in
                    AsyncImage(url: URL(string: images[index])) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 260, height: 180)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 260, height: 180)
                                .clipped()
                                .cornerRadius(16, corners: [.topLeft, .topRight])
                        case .failure:
                            Color.gray
                                .frame(width: 260, height: 180)
                                .cornerRadius(16, corners: [.topLeft, .topRight])
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .tag(index)
                }
            }
            .frame(width: 260, height: 180)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))

            // Название эффекта
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
                .lineLimit(1)
                .padding(.horizontal, 8)

            // Теги и рейтинг
            HStack(spacing: 8) {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color("PrimaryBlue"))
                        .padding(.vertical, 2)
                        .padding(.horizontal, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                Spacer()
                if showRating, let rating = rating {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.pink)
                            .font(.system(size: 14))
                        Text(String(format: "%.1f", rating))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.pink)
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(greyColor, lineWidth: 2)
                .background(Color.white.cornerRadius(20))
        )
        .frame(width: 260)
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
}

// MARK: - CornerRadius для отдельных углов
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

