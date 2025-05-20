//
//  CollectionsScreenView.swift
//  Eflectica
//
//  Created by Анна on 18.05.2025.
//

import SwiftUI

struct CollectionsScreenView: View {
    @ObservedObject var viewModel: CollectionsScreenViewModel

    var body: some View {
        Text(viewModel.greeting)
    }
}
