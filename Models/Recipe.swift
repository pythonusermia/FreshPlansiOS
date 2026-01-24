//
//  Recipe.swift
//  Fresh Plans
//
//  Created by Mia Yonker on 1/14/26.
//
import Foundation
import SwiftData

@Model
class Recipe: Identifiable, Codable {
    @Attribute(.unique) var id: Int
    var title: String
    var image: String
    var sourceUrl: String
    var readyInMinutes: Int
    var servings: Int
    var summary: String?
    var instructions: String?
    
    // UI and Plan State
    var isLocked: Bool = false
    var dayNumber: Int = 1
    var mealType: String = "Dinner"
    var isSavedToPlan: Bool = false
    
    // Social and Notes
    var isHearted: Bool = false
    var userNotes: String = ""
    var folderName: String?
    
    // Ingredients stored as simple strings for the grocery list
    var ingredients: [String] = []

    enum CodingKeys: String, CodingKey {
        case id, title, image, sourceUrl, readyInMinutes, servings, summary, instructions, extendedIngredients
    }
    
    // 1. Standard Initializer
    init(id: Int, title: String, image: String, sourceUrl: String = "", readyInMinutes: Int, servings: Int, summary: String? = nil, instructions: String? = nil, ingredients: [String] = []) {
        self.id = id
        self.title = title
        self.image = image
        self.sourceUrl = sourceUrl
        self.readyInMinutes = readyInMinutes
        self.servings = servings
        self.summary = summary
        self.instructions = instructions
        self.ingredients = ingredients
    }
    
    // 2. Decoding Initializer
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode basic properties
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        image = try container.decode(String.self, forKey: .image)
        sourceUrl = try container.decodeIfPresent(String.self, forKey: .sourceUrl) ?? ""
        readyInMinutes = try container.decode(Int.self, forKey: .readyInMinutes)
        servings = try container.decode(Int.self, forKey: .servings)
        summary = try container.decodeIfPresent(String.self, forKey: .summary)
        instructions = try container.decodeIfPresent(String.self, forKey: .instructions)
        
        // Decode ingredients using the unique helper struct name
        if let ingredientObjects = try container.decodeIfPresent([SpoonacularIngredient].self, forKey: .extendedIngredients) {
            self.ingredients = ingredientObjects.map { $0.original }
        } else {
            self.ingredients = []
        }
    }
    
    // 3. Encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(image, forKey: .image)
        try container.encode(sourceUrl, forKey: .sourceUrl)
        try container.encode(readyInMinutes, forKey: .readyInMinutes)
        try container.encode(servings, forKey: .servings)
        try container.encode(summary, forKey: .summary)
        try container.encode(instructions, forKey: .instructions)
        try container.encode(ingredients, forKey: .extendedIngredients)
    }
}

// Renamed to avoid "Invalid redeclaration" errors
struct SpoonacularIngredient: Codable {
    let original: String
}
