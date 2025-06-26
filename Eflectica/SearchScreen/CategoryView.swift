//
//  CategoryView.swift
//  Eflectica
//
//  Created by Анна on 20.05.2025.
//

import SwiftUI

fileprivate enum SortType {
    case newest
    case popular
}

fileprivate let taskNamesRu: [String: String] = [
    "advertisingProcessing": "Рекламная обработка",
    "atmosphereWeather": "Атмосфера и погода",
    "colorCorrection": "Цветокоррекция",
    "graphicContent": "Графический контент",
    "improvePhotoQuality": "Улучшение качества фото",
]
fileprivate let programNamesRu: [String: String] = [
    "blender": "Blender",
    "fc": "Final Cut",
    "nuke": "Nuke",
    "spark": "Spark AR",
]

struct CategoryView: View {
    let category: Category
    let effects: [Effect]
    
    @State private var showingFilterSheet = false
    @State private var filteredEffects: [Effect]? = nil
    @State private var selectedTasks: [String] = []
    @State private var selectedPrograms: [String] = []
    @State private var sortType: SortType = .newest
    
    private let primaryBlue = Color("PrimaryBlue")
    private let textColor = Color("TextColor")
    private let greyColor = Color("Grey")
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(category.name)
                        .font(.custom("BasisGrotesquePro-Medium", size: 32))
                        .foregroundStyle(primaryBlue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 16)
                    HStack(alignment: .center, spacing: 8) {
                        Menu {
                            Button("Сначала новые") {
                                sortType = .newest
                                sortEffects()
                            }
                            Button("Сначала популярные") {
                                sortType = .popular
                                sortEffects()
                            }
                        } label: {
                            Image("sortIcon")
                                .renderingMode(.template)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
                                .foregroundStyle(textColor)
                        }
                        .buttonStyle(IconSquareButtonStyle())
                        HStack(spacing: 4) {
                            Button(action: { showingFilterSheet = true }) {
                                Image("filterIcon")
                                    .renderingMode(.template)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(textColor)
                            }
                            .buttonStyle(IconSquareButtonStyle())
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(selectedTasks, id: \ .self) { task in
                                        HStack(spacing: 8) {
                                            Text(taskNamesRu[task] ?? task)
                                                .font(.custom("BasisGrotesquePro-Regular", size: 15))
                                                .foregroundColor(primaryBlue)
                                                .frame(maxHeight: .infinity, alignment: .center)
                                                .padding(.leading, 10)
                                            Button(action: {
                                                if let idx = selectedTasks.firstIndex(of: task) { selectedTasks.remove(at: idx) }
                                                sortEffects()
                                            }) {
                                                Image(systemName: "xmark")
                                                    .resizable()
                                                    .frame(width: 14, height: 14)
                                                    .foregroundColor(primaryBlue)
                                                    .padding(.trailing, 10)
                                                    .frame(maxHeight: .infinity, alignment: .center)
                                            }
                                        }
                                        .frame(height: 42)
                                        .background(Color.white)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 6)
                                                .stroke(Color("PrimaryBlue"), lineWidth: 2)
                                        )
                                        .cornerRadius(6)
                                    }
                                    ForEach(selectedPrograms, id: \ .self) { program in
                                        HStack(spacing: 8) {
                                            Text(Program.findByServerId(program)?.name ?? program)
                                                .font(.custom("BasisGrotesquePro-Regular", size: 15))
                                                .foregroundColor(primaryBlue)
                                                .frame(maxHeight: .infinity, alignment: .center)
                                                .padding(.leading, 10)
                                            Button(action: {
                                                if let idx = selectedPrograms.firstIndex(of: program) { selectedPrograms.remove(at: idx) }
                                                sortEffects()
                                            }) {
                                                Image(systemName: "xmark")
                                                    .resizable()
                                                    .frame(width: 14, height: 14)
                                                    .foregroundColor(primaryBlue)
                                                    .padding(.trailing, 10)
                                                    .frame(maxHeight: .infinity, alignment: .center)
                                            }
                                        }
                                        .frame(height: 42)
                                        .background(Color.white)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 6)
                                                .stroke(Color("PrimaryBlue"), lineWidth: 2)
                                        )
                                        .cornerRadius(6)
                                    }
                                }
                            }
                            .frame(height: 42)
                        }
                    }
                    .padding(.leading, 16)
                    .padding(.bottom, 24)
                }
                Divider()
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredEffects ?? effects) { effect in
                            NavigationLink(value: EffectRoute.effectDetail(id: effect.id)) {
                                EffectCardView(
                                    id: effect.id,
                                    images: [effect.afterImage?.url ?? "", effect.beforeImage?.url ?? ""],
                                    name: effect.name,
                                    programs: effect.programs?.map { $0.name } ?? [],
                                    rating: effect.averageRating ?? 0,
                                    isTopEffect: false,
                                    isFullWidth: true
                                )
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .background(Color("LightGrey"))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingFilterSheet) {
            FilterView(effects: effects) { tasks, programs in
                selectedTasks = tasks
                selectedPrograms = programs
                filteredEffects = effects.filter { effect in
                    let matchesTask = tasks.isEmpty || (effect.tasks?.contains(where: { tasks.contains($0) }) ?? false)
                    let matchesProgram = programs.isEmpty || ((effect.programs ?? []).map { $0.name }.contains(where: { programs.contains($0) }))
                    return matchesTask && matchesProgram
                }
                showingFilterSheet = false
            }
        }
    }
    
    private func sortEffects() {
        let sortByNewest: (Effect, Effect) -> Bool = { lhs, rhs in
            let lhsDate = ISO8601DateFormatter().date(from: lhs.createdAt ?? "") ?? .distantPast
            let rhsDate = ISO8601DateFormatter().date(from: rhs.createdAt ?? "") ?? .distantPast
            return lhsDate > rhsDate
        }
        let sortByRating: (Effect, Effect) -> Bool = { lhs, rhs in
            (lhs.averageRating ?? 0) > (rhs.averageRating ?? 0)
        }
        if filteredEffects != nil {
            switch sortType {
            case .newest:
                filteredEffects = filteredEffects?.sorted(by: sortByNewest)
            case .popular:
                filteredEffects = filteredEffects?.sorted(by: sortByRating)
            }
        } else {
            switch sortType {
            case .newest:
                filteredEffects = effects.sorted(by: sortByNewest)
            case .popular:
                filteredEffects = effects.sorted(by: sortByRating)
            }
        }
    }
}

struct IconSquareButtonStyle: ButtonStyle {
    var borderColor: Color = Color("Grey")
    var backgroundColor: Color = Color("WhiteColor")
    var cornerRadius: CGFloat = 6
    var size: CGFloat = 42
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: size, height: size)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: 2)
                    .background(backgroundColor.cornerRadius(cornerRadius))
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
} 
