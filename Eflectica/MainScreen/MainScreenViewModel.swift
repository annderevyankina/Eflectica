//
//  MainScreenViewModel.swift
//  Eflectica
//
//  Created by Анна on 09.04.2025.
//
import SwiftUI

class MainScreenViewModel: ObservableObject {
    // Пример переменной, которая будет отображаться в View
    @Published var greeting: String = "Hello, World!"
    
    // Пример метода, который может изменять данные
    func updateGreeting(newGreeting: String) {
        self.greeting = newGreeting
    }
}
