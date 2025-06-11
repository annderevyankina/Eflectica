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
                HStack(spacing: 16) {
                    Button(action: {
                        // Sort action
                    }) {
                        HStack(spacing: 8) {
                            Image("sortIcon")
                                .renderingMode(.template)
                                .foregroundStyle(textColor)
                            Text("Сортировка")
                                .font(.custom("BasisGrotesquePro-Regular", size: 15))
                                .foregroundStyle(textColor)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(greyColor, lineWidth: 2)
                                .background(Color("WhiteColor").cornerRadius(8))
                        )
                    }
                    
                    Button(action: {
                        showingFilterSheet = true
                    }) {
                        HStack(spacing: 8) {
                            Image("filterIcon")
                                .renderingMode(.template)
                                .foregroundStyle(textColor)
                            Text("Фильтры")
                                .font(.custom("BasisGrotesquePro-Regular", size: 15))
                                .foregroundStyle(textColor)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(greyColor, lineWidth: 2)
                                .background(Color("WhiteColor").cornerRadius(8))
                        )
                    }
                }
                .padding(.horizontal)
                
                // Effects list
                LazyVStack(spacing: 16) {
                    ForEach(effects) { effect in
                        NavigationLink(value: EffectRoute.effectDetail(id: effect.id)) {
                            EffectCardView(
                                id: effect.id,
                                images: [effect.afterImage.url, effect.beforeImage.url],
                                name: effect.name,
                                programs: effect.programList,
                                rating: effect.averageRating,
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