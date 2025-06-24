//
//  Program.swift
//  Eflectica
//
//  Created by Анна on 20.05.2025.
//

import Foundation

struct Program: Identifiable {
    let id: String // Идентификатор с сервера
    let name: String // Полное название для отображения
    let iconName: String // Название иконки в ассетах
    
    static let all: [Program] = [
        Program(id: "photoshop", name: "Adobe Photoshop", iconName: "photoshop_icon"),
        Program(id: "lightroom", name: "Adobe Lightroom", iconName: "lightroom_icon"),
        Program(id: "cinema_4d", name: "Cinema 4D", iconName: "cinema4d_icon"),
        Program(id: "blender", name: "Blender", iconName: "blender_icon"),
        Program(id: "after_effects", name: "Adobe After Effects", iconName: "aftereffects_icon"),
        Program(id: "figma", name: "Figma", iconName: "figma_icon"),
        Program(id: "sketch", name: "Sketch", iconName: "sketch_icon"),
        Program(id: "premiere_pro", name: "Adobe Premiere Pro", iconName: "premiere_icon"),
        Program(id: "davinci", name: "DaVinci Resolve", iconName: "davinci_icon"),
        Program(id: "maya", name: "Autodesk Maya", iconName: "maya_icon"),
        Program(id: "zbrush", name: "ZBrush", iconName: "zbrush_icon"),
        Program(id: "unity", name: "Unity", iconName: "unity_icon"),
        Program(id: "unreal", name: "Unreal Engine", iconName: "unreal_icon"),
        Program(id: "affinity_photo", name: "Affinity Photo", iconName: "affinityphoto_icon"),
        Program(id: "capture_one", name: "Capture One", iconName: "captureone_icon"),
        Program(id: "3ds_max", name: "3ds Max", iconName: "3dsmax_icon"),
        Program(id: "substance", name: "Adobe Substance", iconName: "substance_icon"),
        Program(id: "protopie", name: "ProtoPie", iconName: "protopie_icon"),
        Program(id: "krita", name: "Krita", iconName: "krita_icon"),
        Program(id: "animate", name: "Adobe Animate", iconName: "animate_icon"),
        Program(id: "clip", name: "Clip Studio Paint", iconName: "clip_icon"),
        Program(id: "nuke", name: "Nuke", iconName: "nuke_icon"),
        Program(id: "fc", name: "Final Cut Pro", iconName: "fc_icon"),
        Program(id: "procreate", name: "Procreate", iconName: "procreate_icon"),
        Program(id: "godot", name: "Godot Engine", iconName: "godot_icon"),
        Program(id: "lens", name: "Lens Studio", iconName: "lens_icon"),
        Program(id: "rive", name: "Rive", iconName: "rive_icon"),
        Program(id: "spark", name: "Spark AR Studio", iconName: "spark_icon"),
        Program(id: "spine", name: "Spine", iconName: "spine_icon"),
        Program(id: "toon", name: "Toon Boom Harmony", iconName: "toon_icon")
    ]
    
    static func findByServerId(_ id: String) -> Program? {
        return all.first { $0.id == id }
    }
    
    static func findByIds(_ ids: [String]) -> [Program] {
        return ids.compactMap { findByServerId($0) }
    }
} 
