//
//  EffectDetailView.swift
//  Eflectica
//
//  Created by Анна on 20.05.2025.
//

import SwiftUI

struct EffectDetailView: View {
    let effect: Effect

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text(effect.name)
                    .font(.title)
                AsyncImage(url: URL(string: effect.beforeImage.url)) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    Color.gray
                }
                .frame(height: 200)
                Text(effect.description)
                    .padding()
                Spacer()
            }
            .padding()
        }
        .navigationTitle(effect.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

