import SwiftUI

struct CollectionsListView: View {
    let title: String
    let collections: [Collection]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.custom("BasisGrotesquePro-Medium", size: 32))
                .foregroundColor(Color("PrimaryBlue"))
                .padding(.horizontal)
                .padding(.top, 24)
            if collections.isEmpty {
                Text("Пока нет коллекций")
                    .font(.custom("BasisGrotesquePro-Regular", size: 17))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.top, 40)
                    .frame(maxWidth: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(collections) { collection in
                            CollectionCardView(collection: collection, isFavorite: false, onPlusTap: nil)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                }
            }
            Spacer()
        }
        .background(Color(.systemGray6).ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
} 