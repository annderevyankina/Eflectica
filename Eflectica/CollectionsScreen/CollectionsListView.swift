import SwiftUI

struct CollectionsListView: View {
    let title: String
    let collections: [Collection]
    @State private var selectedCollection: Collection? = nil
    
    // Вынесенная переменная для элементов коллекции
    var collectionElements: [CollectionElement] {
        guard let collection = selectedCollection else { return [] }
        let effects = collection.effects?.map { CollectionElement.effect($0) } ?? []
        let images = collection.images?.map { CollectionElement.image($0) } ?? []
        let links = collection.links?.map { CollectionElement.link($0) } ?? []
        return effects + images + links
    }
    
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
                                .onTapGesture {
                                    selectedCollection = collection
                                }
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
        // Скрытый NavigationLink
        NavigationLink(
            destination: Group {
                if let collection = selectedCollection {
                    ElementsOfCollectionView(
                        elements: collectionElements,
                        collectionName: collection.name
                    )
                }
            },
            isActive: Binding(
                get: { selectedCollection != nil },
                set: { isActive in if !isActive { selectedCollection = nil } }
            )
        ) { EmptyView() }
        .hidden()
    }
} 