//
//  FilterView.swift
//  Eflectica
//
//  Created by Анна on 20.05.2025.
//

import SwiftUI

struct FilterView: View {
    @Environment(\.dismiss) private var dismiss
    let effects: [Effect]
    var onApply: (([String], [String]) -> Void)? = nil

    @State private var selectedTasks: Set<String> = []
    @State private var selectedPrograms: Set<String> = []
    @State private var showAllTasks = false
    @State private var showAllPrograms = false

    private let primaryBlue = Color("PrimaryBlue")
    private let textColor = Color("TextColor")
    private let greyColor = Color("Grey")
    private let whiteColor = Color.white

    // Словари русских названий задач и программ
    private let taskNamesRu: [String: String] = [
        "advertisingProcessing": "Рекламная обработка",
        "atmosphereWeather": "Атмосфера и погода",
        "colorCorrection": "Цветокоррекция",
        "graphicContent": "Графический контент",
        "improvePhotoQuality": "Улучшение качества фото",
        // ...добавь остальные задачи...
    ]

    private var allTasks: [String] {
        Array(Set(effects.compactMap { $0.tasks }.flatMap { $0 })).sorted()
    }
    private var allPrograms: [String] {
        Array(Set(effects.flatMap { $0.programs ?? [] }.map { $0.name })).sorted()
    }
    private var programIcons: [String: String] {
        // Пример: ["Lightroom": "lightroom_icon", ...] — подстрой под свои ассеты
        ["Lightroom": "lightroom_icon", "Photoshop": "photoshop_icon", "Capture One": "captureone_icon", "Affinity Photo": "affinityphoto_icon"]
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.white.ignoresSafeArea()
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Фильтрация")
                        .font(.custom("BasisGrotesquePro-Bold", size: 28))
                        .foregroundColor(primaryBlue)
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(textColor)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 8)

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        // Task section
                        Text("Задача")
                            .font(.custom("BasisGrotesquePro-Medium", size: 20))
                            .foregroundColor(textColor)
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                        let tasksToShow = showAllTasks ? allTasks : Array(allTasks.prefix(5))
                        ForEach(tasksToShow, id: \ .self) { task in
                            FilterRow(title: taskNamesRu[task] ?? task, isSelected: selectedTasks.contains(task), onTap: {
                                if selectedTasks.contains(task) {
                                    selectedTasks.remove(task)
                                } else {
                                    selectedTasks.insert(task)
                                }
                            })
                            if task != tasksToShow.last {
                                Divider().padding(.leading, 20)
                            }
                        }
                        if allTasks.count > 5 {
                            Button(action: { showAllTasks.toggle() }) {
                                HStack {
                                    Text(showAllTasks ? "Скрыть задачи" : "Все задачи")
                                        .font(.custom("BasisGrotesquePro-Regular", size: 17))
                                        .foregroundColor(primaryBlue)
                                    Image(systemName: showAllTasks ? "chevron.up" : "chevron.down")
                                        .foregroundColor(primaryBlue)
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                            }
                        }

                        // Program section
                        Text("Программа")
                            .font(.custom("BasisGrotesquePro-Medium", size: 20))
                            .foregroundColor(textColor)
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        let programsToShow = showAllPrograms ? allPrograms : Array(allPrograms.prefix(5))
                        ForEach(programsToShow, id: \ .self) { program in
                            FilterRow(
                                title: Program.findByServerId(program)?.name ?? program,
                                isSelected: selectedPrograms.contains(program),
                                iconName: programIcons[program],
                                onTap: {
                                    if selectedPrograms.contains(program) {
                                        selectedPrograms.remove(program)
                                    } else {
                                        selectedPrograms.insert(program)
                                    }
                                })
                            if program != programsToShow.last {
                                Divider().padding(.leading, 20)
                            }
                        }
                        if allPrograms.count > 5 {
                            Button(action: { showAllPrograms.toggle() }) {
                                HStack {
                                    Text(showAllPrograms ? "Скрыть программы" : "Все программы")
                                        .font(.custom("BasisGrotesquePro-Regular", size: 17))
                                        .foregroundColor(primaryBlue)
                                    Image(systemName: showAllPrograms ? "chevron.up" : "chevron.down")
                                        .foregroundColor(primaryBlue)
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                            }
                        }
                        Spacer(minLength: 80)
                    }
                }
                // Кнопка Применить
                Button(action: {
                    onApply?(Array(selectedTasks), Array(selectedPrograms))
                    dismiss()
                }) {
                    Text("Применить")
                        .font(.custom("BasisGrotesquePro-Medium", size: 18))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(primaryBlue)
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 24)
                }
            }
        }
    }
}

struct FilterRow: View {
    let title: String
    let isSelected: Bool
    var iconName: String? = nil
    let onTap: () -> Void
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                if let iconName = iconName {
                    Image(iconName)
                        .resizable()
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                }
                Text(title)
                    .font(.custom("BasisGrotesquePro-Regular", size: 17))
                    .foregroundColor(.black)
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color("Grey"), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    if isSelected {
                        Image(systemName: "checkmark")
                            .foregroundColor(Color("PrimaryBlue"))
                    }
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
        }
    }
} 
