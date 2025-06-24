import SwiftUI

struct CollectionCardView: View {
    let collection: Collection
    let isFavorite: Bool
    let onPlusTap: (() -> Void)?
    
    // Собираем до 3 картинок для коллажа (imageUrl или file.url)
    var collageImages: [String] {
        let urls = (collection.images?.compactMap { $0.imageUrl?.isEmpty == false ? $0.imageUrl : $0.file.url } ?? [])
        if urls.isEmpty {
            return ["collection_pict"] // обложка по умолчанию
        }
        return Array(urls.prefix(3))
    }
    var elementsCount: Int {
        (collection.effects?.count ?? 0) + (collection.links?.count ?? 0) + (collection.images?.count ?? 0)
    }
    var effectsCount: Int {
        collection.effects?.count ?? 0
    }
    var titleColor: Color {
        isFavorite ? Color.pink : Color("PrimaryBlue")
    }
    var titleBackground: Color {
        isFavorite ? Color("PinkColor") : Color("PrimaryBlue")
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .leading) {
                    titleBackground
                        .frame(height: 36)
                        .cornerRadius(8, corners: [.topLeft, .topRight])
                    Text(collection.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                }
                CollageView(imageUrls: collageImages)
                    .frame(height: 140)
                    .clipped()
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(elementsCount) элементов")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                    Text("\(effectsCount) эффектов")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 12)
                .padding(.top, 12)
                .padding(.bottom, 16)
            }
            // Кнопка + в правом нижнем углу
            if let onPlusTap = onPlusTap {
                Button(action: onPlusTap) {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(titleColor)
                        .frame(width: 36, height: 36)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(titleColor, lineWidth: 1.5)
                                .background(Color.white.cornerRadius(8))
                        )
                }
                .buttonStyle(PlainButtonStyle())
                .padding(10)
            }
        }
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.07), radius: 8, x: 0, y: 2)
        .frame(width: 220, height: 240)
        .padding(.vertical, 4)
    }
}

// Коллаж из 1-3 картинок
private struct CollageView: View {
    let imageUrls: [String]
    var body: some View {
        GeometryReader { geo in
            if imageUrls.count == 1 {
                collageImage(for: imageUrls[0])
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
            } else if imageUrls.count == 2 {
                HStack(spacing: 2) {
                    collageImage(for: imageUrls[0])
                        .frame(width: geo.size.width / 2 - 1, height: geo.size.height)
                        .clipped()
                    collageImage(for: imageUrls[1])
                        .frame(width: geo.size.width / 2 - 1, height: geo.size.height)
                        .clipped()
                }
            } else if imageUrls.count >= 3 {
                VStack(spacing: 2) {
                    collageImage(for: imageUrls[0])
                        .frame(width: geo.size.width, height: geo.size.height * 0.6)
                        .clipped()
                    HStack(spacing: 2) {
                        collageImage(for: imageUrls[1])
                            .frame(width: geo.size.width / 2 - 1, height: geo.size.height * 0.4)
                            .clipped()
                        collageImage(for: imageUrls[2])
                            .frame(width: geo.size.width / 2 - 1, height: geo.size.height * 0.4)
                            .clipped()
                    }
                }
            }
        }
        .clipped()
        .background(Color(.systemGray5))
        .cornerRadius(0)
    }
    @ViewBuilder
    private func collageImage(for url: String) -> some View {
        if url == "collection_pict" {
            Image("collection_pict")
                .resizable()
                .aspectRatio(1, contentMode: .fill)
        } else if url.hasPrefix("http") {
            AsyncImage(url: URL(string: url)) { phase in
                switch phase {
                case .empty:
                    Color(.systemGray5)
                        .overlay(Image(systemName: "photo").resizable().scaledToFit().foregroundColor(.gray).padding(20))
                case .success(let image):
                    image.resizable().aspectRatio(1, contentMode: .fill)
                case .failure:
                    Color(.systemGray5)
                        .overlay(Image(systemName: "photo").resizable().scaledToFit().foregroundColor(.gray).padding(20))
                @unknown default:
                    Color(.systemGray5)
                }
            }
        } else {
            Image(url)
                .resizable()
                .aspectRatio(1, contentMode: .fill)
        }
    }
} 