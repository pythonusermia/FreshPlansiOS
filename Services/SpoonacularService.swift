//
//  SpoonacularService.swift
//  Fresh Plans
//
//  Created by Mia Yonker on 1/14/26.
//

import Foundation

class SpoonacularService {
    // IMPORTANT: Your API key is now active in this service
    let apiKey = "2957835553f34cc1bac5960d967b6a6c"
    
    func fetchFilteredRecipes(type: String, diet: String, exclusions: String, favorites: [String] = []) async throws -> [Recipe] {
        var urlComponents = URLComponents(string: "https://api.spoonacular.com/recipes/complexSearch")!
        
        let searchQuery = favorites.isEmpty ? "" : favorites.joined(separator: " OR ")
        
        let items: [URLQueryItem] = [
            URLQueryItem(name: "apiKey", value: apiKey),
            URLQueryItem(name: "query", value: searchQuery),
            URLQueryItem(name: "type", value: type),
            URLQueryItem(name: "diet", value: diet.lowercased()),
            URLQueryItem(name: "excludeIngredients", value: exclusions),
            URLQueryItem(name: "number", value: "15"), // Fetch a few extra to allow for better sorting
            URLQueryItem(name: "addRecipeInformation", value: "true"),
            URLQueryItem(name: "fillIngredients", value: "true")
        ]
        
        urlComponents.queryItems = items
        
        guard let url = urlComponents.url else { throw URLError(.badURL) }
        
        // Perform the network request
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoded = try JSONDecoder().decode(SearchResponse.self, from: data)
        let results = decoded.results
        
        // Sort results to prioritize favorite websites if they match the sourceUrl
        let sortedResults = results.sorted(by: { res1, res2 in
            let match1 = favorites.contains { site in
                res1.sourceUrl.localizedCaseInsensitiveContains(site)
            }
            let match2 = favorites.contains { site in
                res2.sourceUrl.localizedCaseInsensitiveContains(site)
            }
            
            if match1 == match2 { return false }
            return match1
        })
        
        return sortedResults
    }
    
    func fetchRecipeDetails(ids: [Int]) async throws -> [RecipeDetailResponse] {
        let idString = ids.map { String($0) }.joined(separator: ",")
        let urlString = "https://api.spoonacular.com/recipes/informationBulk?apiKey=\(apiKey)&ids=\(idString)&includeNutrition=false"
        
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([RecipeDetailResponse].self, from: data)
    }
}

// MARK: - Models
struct SearchResponse: Codable {
    let results: [Recipe]
}

struct RecipeDetailResponse: Codable {
    let id: Int
    let extendedIngredients: [Ingredient]
}

struct Ingredient: Identifiable, Codable {
    var id: Int?
    let name: String
    let amount: Double
    let unit: String
    var isChecked: Bool = false
    
    var displayLabel: String {
        "\(amount.formatted()) \(unit) \(name.capitalized)"
    }
}
