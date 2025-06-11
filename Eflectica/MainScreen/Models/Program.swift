import Foundation

struct Program: Identifiable {
    let id: String // Идентификатор с сервера
    let name: String // Полное название для отображения
    let iconName: String // Название иконки в ассетах
    
    static let all: [Program] = [
        Program(id: "photoshop", name: "Adobe Photoshop", iconName: "photoshop_icon"),
        Program(id: "lightroom", name: "Adobe Lightroom", iconName: "lightroom_icon"),
        Program(id: "cinema4d", name: "Cinema 4D", iconName: "cinema4d_icon"),
        Program(id: "blender", name: "Blender", iconName: "blender_icon"),
        Program(id: "after_effects", name: "Adobe After Effects", iconName: "aftereffects_icon"),
        Program(id: "figma", name: "Figma", iconName: "figma_icon"),
        Program(id: "sketch", name: "Sketch", iconName: "sketch_icon"),
        Program(id: "premiere", name: "Adobe Premiere Pro", iconName: "premiere_icon"),
        Program(id: "davinci", name: "DaVinci Resolve", iconName: "davinci_icon"),
        Program(id: "maya", name: "Autodesk Maya", iconName: "maya_icon"),
        Program(id: "zbrush", name: "ZBrush", iconName: "zbrush_icon"),
        Program(id: "unity", name: "Unity", iconName: "unity_icon"),
        Program(id: "unreal", name: "Unreal Engine", iconName: "unreal_icon")
    ]
    
    static func findByServerId(_ id: String) -> Program? {
        return all.first { $0.id == id }
    }
    
    static func findByIds(_ ids: [String]) -> [Program] {
        return ids.compactMap { findByServerId($0) }
    }
} 