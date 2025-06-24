import Foundation

struct TaskInfo {
    let id: String
    let title: String
}

let allTasks: [TaskInfo] = [
    TaskInfo(id: "portraitRetouching", title: "Ретушь портрета"),
    TaskInfo(id: "colorCorrection", title: "Цветокоррекция"),
    TaskInfo(id: "improvePhotoQuality", title: "Улучшить качество фото"),
    TaskInfo(id: "preparationForPrinting", title: "Подготовка к печати"),
    TaskInfo(id: "socialMediaContent", title: "Контент для соцсетей"),
    TaskInfo(id: "advertisingProcessing", title: "Рекламная обработка"),
    TaskInfo(id: "stylization", title: "Стилизация"),
    TaskInfo(id: "backgroundEditing", title: "Редактирование фона"),
    TaskInfo(id: "graphicContent", title: "Графический контент"),
    TaskInfo(id: "setLight", title: "Настройка света"),
    TaskInfo(id: "simulation3d", title: "Симуляция 3D"),
    TaskInfo(id: "atmosphereWeather", title: "Атмосфера и погода")
]

let taskDescriptions: [String: String] = Dictionary(uniqueKeysWithValues: allTasks.map { ($0.id, $0.title) }) 