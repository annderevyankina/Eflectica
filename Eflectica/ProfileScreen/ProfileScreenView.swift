//
//  ProfileView.swift
//  Eflectica
//
//  Created by Анна on 18.05.2025.
//

import SwiftUI

struct ProfileScreenView: View {
    @ObservedObject var viewModel: ProfileScreenViewModel

    var body: some View {
        Text(viewModel.greeting)
    }
}
