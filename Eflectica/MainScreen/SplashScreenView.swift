//
//  SplashScreenView.swift
//  Eflectica
//
//  Created by Анна on 20.05.2025.
//

import SwiftUI

struct SplashScreenView: View {
    @Binding var isShowingSplash: Bool
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var opacity = 0.5
    @State private var scale = 1.0
    
    var body: some View {
        ZStack {
            Color("AccentColor")
                .ignoresSafeArea()
                .opacity(opacity)
            
            Image("eflecticaIcon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height: 250)
                .offset(y: -20)
                .opacity(opacity)
                .scaleEffect(scale)
                .shadow(radius: 10)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.opacity = 1.0
                    }
                    
                    withAnimation(.easeInOut(duration: 0.7).delay(1.2)) {
                        self.scale = 1.08
                    }
                    withAnimation(.easeInOut(duration: 0.7).delay(1.7)) {
                        self.scale = 1.0
                    }
                }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeOut(duration: 0.7)) {
                    self.scale = 1.3
                    self.opacity = 0.0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.isShowingSplash = false
                }
            }
        }
    }
}
