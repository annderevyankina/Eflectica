//
//  MainScreenView.swift
//  Eflectica
//
//  Created by Анна on 09.04.2025.
//
import SwiftUI

struct MainScreenView: View {
    @ObservedObject var viewModel: MainScreenViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.greeting)
                .font(.largeTitle)
                .padding()
            
            Button("Update Greeting") {
                viewModel.updateGreeting(newGreeting: "Hello, Swift!")
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
}
