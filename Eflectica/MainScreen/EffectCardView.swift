//
//  EffectCardView.swift
//  Eflectica
//
//  Created by Анна on 21.05.2025.
//

import SwiftUI

struct EffectCardView: View {
    let id: Int
    let images: [String]         
    let name: String
    let programs: [String]
    let rating: Double
    let isTopEffect: Bool
    let isFullWidth: Bool
    
    private let greyColor = Color("Grey")
    private let cornerRadius: CGFloat = 12
    
    init(id: Int, images: [String], name: String, programs: [String], rating: Double, isTopEffect: Bool, isFullWidth: Bool = false) {
        self.id = id
        self.images = images
        self.name = name
        self.programs = programs
        self.rating = rating
        self.isTopEffect = isTopEffect
        self.isFullWidth = isFullWidth
        _selectedImage = State(initialValue: 0)
    }

    @State private var selectedImage: Int
    
    private var programModels: [Program] {
        Program.findByIds(programs)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Image slider with before/after images
            TabView(selection: $selectedImage) {
                ForEach(images.indices, id: \.self) { index in
                    AsyncImage(url: URL(string: images[index])) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .frame(height: isFullWidth ? 240 : 180)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: isFullWidth ? 240 : 180)
                                .clipped()
                        case .failure:
                            Color.gray
                                .frame(maxWidth: .infinity)
                                .frame(height: isFullWidth ? 240 : 180)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .tag(index)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: isFullWidth ? 240 : 180)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            .id(id)

            Text(name)
                .font(.system(size: isFullWidth ? 17 : 14, weight: .medium))
                .foregroundColor(.primary)
                .lineLimit(1)
                .padding(.horizontal, 8)

            HStack(spacing: 8) {
                if !programModels.isEmpty {
                    if isTopEffect {
                        // Display only program icons for top effects
                        HStack(spacing: 8) {
                            ForEach(programModels, id: \.name) { program in
                                Image(program.iconName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                            }
                        }
                    } else {
                        // Display icon and name for regular effects
                        HStack(spacing: 8) {
                            Image(programModels[0].iconName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            
                            if programModels.count == 1 {
                                Text(programModels[0].name)
                                    .font(.system(size: isFullWidth ? 17 : 14, weight: .medium))
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                }
                
                Spacer()
                
                if isTopEffect || isFullWidth {
                    HStack(spacing: 2) {
                        Image("starIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: isFullWidth ? 28 : 14, height: isFullWidth ? 28 : 14)
                        Text(String(format: "%.1f", rating))
                            .font(.system(size: isFullWidth ? 17 : 14, weight: .medium))
                            .foregroundColor(Color("PinkColor"))
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(greyColor, lineWidth: 2)
                .background(Color.white.cornerRadius(cornerRadius))
        )
        .frame(width: isFullWidth ? nil : 260)
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
        .onAppear {
            selectedImage = 0
        }
    }
}

// Helper extension for applying corner radius to specific corners
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

