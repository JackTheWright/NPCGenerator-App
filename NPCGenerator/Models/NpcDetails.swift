//
//  NpcDetails.swift
//  NPCGenerator
//
//  Created by Jack Wright on 2024-09-18.
//

import Foundation

class NpcDetails: Codable, Hashable {
    var id: Int
    var name: String
    var age: Int
    var race: String
    var gender: String
    var profession: String
    var hairstyle: String
    var standoutFeature: String
    var personalityTrait: String
    var accent: String

    init(
        id: Int,
        name: String,
        age: Int,
        race: String,
        gender: String,
        profession: String,
        hairstyle: String,
        standoutFeature: String,
        personalityTrait: String,
        accent: String
    ) {
        self.id = id
        self.name = name
        self.age = age
        self.race = race
        self.gender = gender
        self.profession = profession
        self.hairstyle = hairstyle
        self.standoutFeature = standoutFeature
        self.personalityTrait = personalityTrait
        self.accent = accent
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case age
        case race
        case gender
        case profession
        case hairstyle
        case standoutFeature
        case personalityTrait
        case accent
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.age = try container.decode(Int.self, forKey: .age)
        self.race = try container.decode(String.self, forKey: .race)
        self.gender = try container.decode(String.self, forKey: .gender)
        self.profession = try container.decode(String.self, forKey: .profession)
        self.hairstyle = try container.decode(String.self, forKey: .hairstyle)
        self.standoutFeature = try container.decode(String.self, forKey: .standoutFeature)
        self.personalityTrait = try container.decode(String.self, forKey: .personalityTrait)
        self.accent = try container.decode(String.self, forKey: .accent)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(age, forKey: .age)
        try container.encode(race, forKey: .race)
        try container.encode(gender, forKey: .gender)
        try container.encode(profession, forKey: .profession)
        try container.encode(hairstyle, forKey: .hairstyle)
        try container.encode(standoutFeature, forKey: .standoutFeature)
        try container.encode(personalityTrait, forKey: .personalityTrait)
        try container.encode(accent, forKey: .accent)
    }

    static func == (lhs: NpcDetails, rhs: NpcDetails) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.age == lhs.age &&
        lhs.race == rhs.race &&
        lhs.gender == rhs.gender &&
        lhs.hairstyle == rhs.hairstyle &&
        lhs.personalityTrait == rhs.personalityTrait &&
        lhs.standoutFeature == rhs.standoutFeature &&
        lhs.accent == rhs.accent
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(age)
        hasher.combine(race)
        hasher.combine(gender)
        hasher.combine(hairstyle)
        hasher.combine(personalityTrait)
        hasher.combine(standoutFeature)
        hasher.combine(accent)
    }
}

struct PaginatedData<M: NpcDetails>: Decodable {
    enum CodingKeys: String, CodingKey {
        case jsonData = "content"
        case page
    }

    let jsonData: [M]
    let page: Paging

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.page = try container.decode(Paging.self, forKey: CodingKeys.page)
        self.jsonData = try container.decode([M].self, forKey: .jsonData)
    }

    init() {
        self.jsonData = []
        self.page = Paging()
    }
}

class Paging: Codable {
    private enum CodingKeys: String, CodingKey {
        case size
        case number
        case totalElements
        case totalPages
    }
    let size: Double
    let number: Double
    let totalElements: Double
    let totalPages: Double

    init(
        size: Double,
        number: Double,
        totalElements: Double,
        totalPages: Double
    ) {
        self.size = size
        self.number = number
        self.totalElements = totalElements
        self.totalPages = totalPages
    }

    convenience init() {
        self.init(
            size: 1,
            number: 0,
            totalElements: 1,
            totalPages: 1
        )
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.size = try container.decode(Double.self, forKey: .size)
        self.number = try container.decode(Double.self, forKey: .number)
        self.totalElements = try container.decode(Double.self, forKey: .totalElements)
        self.totalPages = try container.decode(Double.self, forKey: .totalPages)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(size, forKey: .size)
        try container.encode(number, forKey: .number)
        try container.encode(totalElements, forKey: .totalElements)
        try container.encode(totalPages, forKey: .totalPages)
    }
}
