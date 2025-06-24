//
//  CategoryView.swift
//  Eflectica
//
//  Created by Анна on 20.05.2025.
//

import SwiftUI

struct CategoryView: View {
    let category: Category
    let effects: [Effect]
    
    @State private var showingFilterSheet = false
    
    private let primaryBlue = Color("PrimaryBlue")
    private let textColor = Color("TextColor")
    private let greyColor = Color("Grey")
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text(category.name)
                    .font(.custom("BasisGrotesquePro-Medium", size: 32))
                    .foregroundStyle(primaryBlue)
                    .padding(.horizontal)
                    .padding(.top, 16)
                
                // Sort and Filter buttons
                HStack(spacing: 8) {
                    Button(action: {
                        // Sort action
                    }) {
                        Image("sortIcon")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(10)
                            .foregroundStyle(textColor)
                    }
                    .buttonStyle(IconSquareButtonStyle())
                    
                    Button(action: {
                        showingFilterSheet = true
                    }) {
                        Image("filterIcon")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(10)
                            .foregroundStyle(textColor)
                    }
                    .buttonStyle(IconSquareButtonStyle())
                }
                .padding(.horizontal)
                
                // Effects list
                LazyVStack(spacing: 16) {
                    ForEach(effects) { effect in
                        NavigationLink(value: EffectRoute.effectDetail(id: effect.id)) {
                            EffectCardView(
                                id: effect.id,
                                images: [effect.afterImage?.url ?? "", effect.beforeImage?.url ?? ""],
                                name: effect.name,
                                programs: effect.programs?.map { $0.name } ?? [],
                                rating: effect.averageRating ?? 0,
                                isTopEffect: false,
                                isFullWidth: true
                            )
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .background(Color("LightGrey"))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingFilterSheet) {
            FilterView()
        }
    }
}

struct IconSquareButtonStyle: ButtonStyle {
    var borderColor: Color = Color("Grey")
    var backgroundColor: Color = Color("WhiteColor")
    var cornerRadius: CGFloat = 6
    var size: CGFloat = 42
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: size, height: size)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: 2)
                    .background(backgroundColor.cornerRadius(cornerRadius))
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
} 
