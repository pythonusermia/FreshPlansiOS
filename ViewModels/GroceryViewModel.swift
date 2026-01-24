//
//  GroceryViewModel.swift
//  Fresh Plans
//
//  Created by Mia Yonker on 1/15/26.
//
import Foundation
import Observation

@Observable
class GroceryViewModel {
    var ingredients: [Ingredient] = []
    var isLoading = false
    private let service = SpoonacularService()
    
    // This allows the share button to work
    var shareableList: String {
        let needed = ingredients.filter { !$0.isChecked }
        if needed.isEmpty { return "No items to buy!" }
        let listBody = needed.map { "- \($0.displayLabel)" }.joined(separator: "\n")
        return "My Grocery List from Fresh Plans:\n\n\(listBody)"
    }
    
    func fetchIngredients(for recipeIds: [Int]) async {
        guard !recipeIds.isEmpty else { return }
        isLoading = true
        do {
            let details = try await service.fetchRecipeDetails(ids: recipeIds)
            let allIngredients = details.flatMap { $0.extendedIngredients }
            
            await MainActor.run {
                self.ingredients = allIngredients
                self.isLoading = false
            }
        } catch {
            print("Error: \(error)")
            isLoading = false
        }
    }
    
    func toggleIngredient(_ id: Int?) {
        if let index = ingredients.firstIndex(where: { $0.id == id }) {
            // Using a simple toggle here keeps the logic clean
            ingredients[index].isChecked.toggle()
        }
    }
}
