//
//  ElementOfCollectionView.swift
//  Eflectica
//
//  Created by Анна on 25.06.2025.
//

import Foundation

struct CollectionEffectElement: Decodable, Identifiable {
    let id: Int
    let name: String
    let img: EffectImage
    let description: String
    let programs: [EffectProgram]?
    let programsWithVersions: [EffectProgram]?

    enum CodingKeys: String, CodingKey {
        case id, name, img, description, programs
        case programsWithVersions = "programs_with_versions"
    }

    var allPrograms: [EffectProgram]? {
        programs ?? programsWithVersions
    }
}

