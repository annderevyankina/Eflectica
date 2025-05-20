//
//  SearchScreenView.swift
//  Eflectica
//
//  Created by Анна on 18.05.2025.
//

import SwiftUI

struct SearchScreenView: View {
    @ObservedObject var viewModel: SearchScreenViewModel

    var body: some View {
        Text(viewModel.greeting)
    }
}
